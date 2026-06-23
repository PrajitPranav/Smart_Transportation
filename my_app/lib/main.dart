  import 'package:flutter/material.dart';
  import 'dart:math';
  import 'package:url_launcher/url_launcher.dart';
  import 'package:intl/intl.dart';
  import 'bus_data_loader.dart';
  import 'booking_model.dart';
  // import 'signup_page.dart'; // Make sure the file name matches
  import 'package:local_auth/local_auth.dart';
  import 'splash_auth_page.dart';
  void main() {
    runApp(const MyApp());
  }


class MyBookingsPage extends StatefulWidget {
  const MyBookingsPage({super.key});

  @override
  State<MyBookingsPage> createState() => _MyBookingsPageState();
}

class _MyBookingsPageState extends State<MyBookingsPage> {
  List<bool> isExpanded = [];

  @override
  void initState() {
    super.initState();
    final bookings = BookingStorage().bookings;
    isExpanded = List.generate(bookings.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    final bookings = BookingStorage().bookings;

    return Scaffold(
      appBar: AppBar(title: const Text("My Bookings")),
      body: bookings.isEmpty
          ? const Center(child: Text("No bookings yet."))
          : ListView.builder(
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final bus = bookings[index];

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      isExpanded[index] = !isExpanded[index];
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.lightBlue[50],
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(color: Colors.grey, blurRadius: 6, offset: Offset(0, 3)),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(bus.busName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        Text("Route: ${bus.from} → ${bus.to}"),
                        Text("Seats: ${bus.seats}"),
                        Text("Arrival: ${bus.arrival}"),
                        AnimatedCrossFade(
                          firstChild: const SizedBox.shrink(),
                          secondChild: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Divider(),
                              Text("Bus Type: ${bus.type}"),
                              Text("Driver Name: ${bus.driverName}"),
                              Text("Bus No: ${bus.number}"),
                            ],
                          ),
                          crossFadeState: isExpanded[index]
                              ? CrossFadeState.showSecond
                              : CrossFadeState.showFirst,
                          duration: const Duration(milliseconds: 300),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}



  class BottomNavWrapper extends StatefulWidget {
    const BottomNavWrapper({super.key});

    @override
    State<BottomNavWrapper> createState() => _BottomNavWrapperState();
  }

  class _BottomNavWrapperState extends State<BottomNavWrapper> {
    int _currentIndex = 0;

    final List<Widget> _screens = [
      const HomeScreen(),
      const MyBookingsPage(),
      const AccountScreen(),
    ];

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: _screens[_currentIndex],
        bottomNavigationBar: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNavItem(icon: Icons.home, label: 'Home', index: 0),
                _buildNavItem(icon: Icons.book_online, label: 'Bookings', index: 1),
                _buildNavItem(icon: Icons.account_circle, label: 'Account', index: 2),
              ],
            ),
          ),
        ),
      );
    }

    Widget _buildNavItem({required IconData icon, required String label, required int index}) {
      final isSelected = _currentIndex == index;
      return GestureDetector(
        onTap: () => setState(() => _currentIndex = index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isSelected ? Colors.blue : Colors.grey),
            Text(label, style: TextStyle(color: isSelected ? Colors.blue : Colors.grey)),
          ],
        ),
      );
    }
  }

  class Bus {
    String name;
    int seatingCapacity;
    String arrivalTime;
    bool hasDelay;
    String delayReason;
    double latitude;
    double longitude;
    IconData icon;
    bool petFriendly;

    Bus({
      required this.name,
      required this.seatingCapacity,
      required this.arrivalTime,
      required this.hasDelay,
      required this.delayReason,
      required this.latitude,
      required this.longitude,
      required this.icon,
      required this.petFriendly,
    });
  }
 class BookingStorage {
  List<Map<String, dynamic>> _storedBookings = [];

  List<Booking> get bookings => _storedBookings.map((e) => Booking.fromJson(e)).toList();
}

  class MyApp extends StatelessWidget {
    const MyApp({super.key});

    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        title: 'Smart Transportation',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.teal),
        home: const SplashAuthPage(),
        
      );
    }
  }



class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LocalAuthentication auth = LocalAuthentication();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool showLoginFields = false;

  Future<void> _authenticate() async {
    bool isAuthenticated = false;
    try {
      isAuthenticated = await auth.authenticate(
        localizedReason: 'Please authenticate to login',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      if (isAuthenticated) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const BottomNavWrapper()),
        );
      } else {
        setState(() {
          showLoginFields = true; // Show manual login if fingerprint fails
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Fingerprint not recognized. Please login manually.')),
        );
      }
    } catch (e) {
      setState(() {
        showLoginFields = true;
      });
      print("Error using fingerprint: $e");
    }
  }

  void _manualLogin() {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (username == 'user@gmail.com' && password == '123') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const BottomNavWrapper()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid username or password')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _authenticate(); // Trigger fingerprint scan immediately
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (showLoginFields) ...[
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(labelText: "Username"),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Password"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _manualLogin,
                child: const Text("Login"),
              ),
            ] else ...[
              const Text("Authenticating using Fingerprint..."),
            ],
          ],
        ),
      ),
    );
  }
}


  class HomeScreen extends StatefulWidget {
    const HomeScreen({super.key});
    @override
    State<HomeScreen> createState() => _HomeScreenState();
  }

class _HomeScreenState extends State<HomeScreen> {
  final fromController = TextEditingController();
  final toController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  List<Bus> myBookings = [];
  List<Bus> searchedBuses = [];
  bool showPetFriendlyOnly = false;
  List<Map<String, dynamic>> allBusRoutes = [];
  List<Map<String, dynamic>> busData = [];

  @override
void initState() {
  super.initState();
  loadBusData().then((data) {
    setState(() {
      busData = data;
      allBusRoutes = data;
    });
  });
}

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  void selectToday() => setState(() => selectedDate = DateTime.now());
  void selectTomorrow() => setState(() => selectedDate = DateTime.now().add(const Duration(days: 1)));

  void searchBuses() {
    if (fromController.text.isEmpty || toController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill 'From' and 'To' fields")),
      );
      return;
    }

    List<Bus> buses = allBusRoutes.where((route) =>
      route['from'] == fromController.text && route['to'] == toController.text
    ).map((route) {
      final random = Random();
      return Bus(
        name: route['busName'],
        seatingCapacity: route['seats'],
        arrivalTime: '${random.nextInt(60) + 1} mins',
        hasDelay: random.nextBool(),
        delayReason: 'Traffic',
        latitude: double.parse(route['latitude'].toString()),
        longitude: double.parse(route['longitude'].toString()),
        icon: Icons.directions_bus,
        petFriendly: route['petFriendly'],
      );
    }).toList();

    setState(() {
      searchedBuses = buses;
    });
  }

  Future<void> _launchMap(double lat, double lng) async {
    final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch map';
    }
  }

  void _bookBus(Bus bus) {
    BookingStorage().bookings.add(bus as Booking);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Bus booked successfully!")),
    );
  }

  Widget _buildBusCard(Bus bus, {bool isMyBooking = false}) {
    return Card(
      margin: const EdgeInsets.all(8),
      color: isMyBooking ? Colors.blue.shade50 : Colors.white,
      child: ListTile(
        leading: Icon(bus.icon, size: 40, color: Colors.lightBlue),
        title: Text(bus.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Seats: ${bus.seatingCapacity}'),
            if (bus.petFriendly) const Text('Pet Friendly 🐶'),
            if (isMyBooking) Text('Arrival in: ${bus.arrivalTime}'),
            if (isMyBooking && bus.hasDelay)
              Text('Delayed: ${bus.delayReason}', style: const TextStyle(color: Colors.red)),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: isMyBooking ? () => _launchMap(bus.latitude, bus.longitude) : () => _bookBus(bus),
          child: Text(isMyBooking ? "Track" : "Book Ticket"),
        ),
      ),
    );
  }

  final List<String> offers = ['Save up to ₹250', 'Flat ₹100 off', '20% Cashback', 'Weekend Offer'];
  final List<IconData> offerIcons = [Icons.discount, Icons.monetization_on, Icons.card_giftcard, Icons.weekend];
  final List<Map<String, dynamic>> whatsNewItems = [
    {'text': 'Free Cancellation', 'icon': Icons.cancel_schedule_send},
    {'text': 'Introducing Timetable', 'icon': Icons.schedule},
    {'text': 'Refer and Earn', 'icon': Icons.group_add},
    {'text': 'Fast Refund', 'icon': Icons.attach_money},
    {'text': '24x7 Support', 'icon': Icons.support_agent},
    {'text': 'Wallet Support', 'icon': Icons.account_balance_wallet},
    {'text': 'Live Tracking', 'icon': Icons.location_on},
    {'text': 'Offers & Deals', 'icon': Icons.local_offer},
  ];

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('dd MMM, yyyy').format(selectedDate);
    List<Bus> filteredBuses = showPetFriendlyOnly
        ? searchedBuses.where((bus) => bus.petFriendly).toList()
        : searchedBuses;

    final List<String> places = allBusRoutes
        .map((route) => route['from'].toString())
        .toSet()
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Bus Booking')),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.lightBlue),
              child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Book Bus'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.book_online),
              title: const Text('My Bookings'),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('My Bookings'),
                    content: SizedBox(
                      height: 400,
                      width: 300,
                      child: ListView(
                        children: BookingStorage().bookings.map((bus) => _buildBusCard(bus as Bus, isMyBooking: true)).toList(),
                      ),
                    ),
                    actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("Close"))],
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text('Account'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const AccountScreen()));
              },
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text("Bus Tickets", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'From',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            value: fromController.text.isEmpty ? null : fromController.text,
            items: places.map((place) => DropdownMenuItem(value: place, child: Text(place))).toList(),
            onChanged: (value) {
              setState(() {
                fromController.text = value!;
                if (toController.text == value) toController.clear();
              });
            },
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'To',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            value: toController.text.isEmpty ? null : toController.text,
            items: places.where((place) => place != fromController.text).map((place) => DropdownMenuItem(value: place, child: Text(place))).toList(),
            onChanged: (value) => setState(() => toController.text = value!),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(border: Border.all(color: Colors.lightBlue), borderRadius: BorderRadius.circular(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Date: $formattedDate", style: const TextStyle(fontSize: 16)),
                    Row(
                      children: [
                        TextButton(onPressed: selectToday, child: const Text("Today")),
                        TextButton(onPressed: selectTomorrow, child: const Text("Tomorrow")),
                        IconButton(onPressed: _pickDate, icon: const Icon(Icons.calendar_month)),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Pet Friendly"),
                    Switch(value: showPetFriendlyOnly, onChanged: (value) => setState(() => showPetFriendlyOnly = value)),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: searchBuses,
            icon: const Icon(Icons.search),
            label: const Text("Search Buses"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightBlue,
              minimumSize: const Size.fromHeight(50),
              textStyle: const TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 20),
          const Text("Offers for You", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: offers.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.blue[50],
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Container(
                    width: 200,
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Icon(offerIcons[index], color: Colors.blue),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            offers[index],
                            style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          const Text("What's New", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: whatsNewItems.length,
              itemBuilder: (context, index) {
                return Container(
                  width: 200,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(whatsNewItems[index]['icon'], size: 32, color: Colors.blue),
                      const SizedBox(height: 8),
                      Text(
                        whatsNewItems[index]['text'],
                        style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.blue),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          if (filteredBuses.isNotEmpty) const Text("Available Buses:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ...filteredBuses.map((bus) => _buildBusCard(bus, isMyBooking: false)),
        ],
      ),
    );
  }
}


  class AccountScreen extends StatelessWidget {
    const AccountScreen({super.key});

    final List<Map<String, dynamic>> accountItems = const [
      {'icon': Icons.book, 'label': 'Bookings'},
      {'icon': Icons.person, 'label': 'Personal Info'},
      {'icon': Icons.group, 'label': 'Passengers'},
      {'icon': Icons.account_balance_wallet, 'label': 'Wallet'},
      {'icon': Icons.payment, 'label': 'Payment Methods'},
      {'icon': Icons.local_offer, 'label': 'Offers'},
      {'icon': Icons.card_giftcard, 'label': 'Referrals'},
      {'icon': Icons.help_outline, 'label': 'Help'},
      {'icon': Icons.settings, 'label': 'Account Settings'},
      {'icon': Icons.logout, 'label': 'Log Out'},
    ];

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: const Text("Account")),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.count(
    crossAxisCount: 2,
    crossAxisSpacing: 16,
    mainAxisSpacing: 16,
    children: List.generate(accountItems.length, (index) {
      final item = accountItems[index];

      // Custom handling for logout
      if (item['label'] == 'Log Out') {
        return GestureDetector(
          onTap: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LoginPage()),
              (route) => false,
            );
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(item['icon'], size: 36, color: Colors.red),
                const SizedBox(height: 10),
                Text(
                  item['label'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      }

      // For all other items
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(item['icon'], size: 36, color: Colors.blue),
            const SizedBox(height: 10),
            Text(
              item['label'],
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.blue,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }),
  )

        ),
      );
    }
  }
