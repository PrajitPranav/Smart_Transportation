// ... (import statements stay the same)
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

// Bus class remains unchanged
class Bus {
  String name;
  int seatingCapacity;
  String arrivalTime;
  bool hasDelay;
  String delayReason;
  double latitude;
  double longitude;
  IconData icon;

  Bus({
    required this.name,
    required this.seatingCapacity,
    required this.arrivalTime,
    required this.hasDelay,
    required this.delayReason,
    required this.latitude,
    required this.longitude,
    required this.icon,
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bus Booking App',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// HomeScreen and _HomeScreenState stay mostly the same
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

  List<Bus> generateRandomBuses(int count) {
    final random = Random();
    final names = ['ExpressLine', 'CityBus', 'TravelX', 'SpeedBus', 'EcoRide', 'MetroLink', 'FastTrack', 'SwiftGo', 'GreenBus', 'RedExpress'];
    return List.generate(count, (index) {
      int capacity = random.nextInt(40) + 10;
      int arrivalInMin = random.nextInt(60) + 1;
      bool delay = random.nextBool();
      String reason = delay ? ['Traffic', 'Breakdown', 'Weather'][random.nextInt(3)] : '';
      double baseLat = 11.6643;
      double baseLng = 78.1460;
      double randomLat = baseLat + random.nextDouble() * 0.05;
      double randomLng = baseLng + random.nextDouble() * 0.05;

      return Bus(
        name: names[random.nextInt(names.length)],
        seatingCapacity: capacity,
        arrivalTime: '$arrivalInMin mins',
        hasDelay: delay,
        delayReason: reason,
        latitude: randomLat,
        longitude: randomLng,
        icon: Icons.directions_bus,
      );
    });
  }

  void searchBuses() {
    if (fromController.text.isEmpty || toController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill 'From' and 'To' fields")),
      );
      return;
    }

    setState(() {
      myBookings = generateRandomBuses(10);
      searchedBuses = generateRandomBuses(5);
    });
  }

  Future<void> _launchMap(double lat, double lng) async {
    final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch map';
    }
  }

  Widget _buildBusCard(Bus bus) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        leading: Icon(bus.icon, size: 40, color: Colors.lightBlue),
        title: Text(bus.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Seats: ${bus.seatingCapacity}'),
            Text('Arrival in: ${bus.arrivalTime}'),
            if (bus.hasDelay) Text('Delayed due to: ${bus.delayReason}', style: const TextStyle(color: Colors.red)),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () => _launchMap(bus.latitude, bus.longitude),
          child: const Text("Track Bus"),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('dd MMM, yyyy').format(selectedDate);

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
                        children: myBookings.map(_buildBusCard).toList(),
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
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text("Bus Tickets", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          TextField(controller: fromController, decoration: const InputDecoration(labelText: 'From', border: OutlineInputBorder())),
          const SizedBox(height: 10),
          TextField(controller: toController, decoration: const InputDecoration(labelText: 'To', border: OutlineInputBorder())),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Date of Journey: $formattedDate", style: const TextStyle(fontSize: 16)),
              TextButton(onPressed: _pickDate, child: const Text("Change Date"))
            ],
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: searchBuses,
            icon: const Icon(Icons.search),
            label: const Text("Search Buses"),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlue),
          ),
          const SizedBox(height: 20),
          if (searchedBuses.isNotEmpty) const Text("Available Buses:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ...searchedBuses.map(_buildBusCard),
        ],
      ),
    );
  }
}

// ✅ New AccountScreen added here
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
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        itemCount: accountItems.length,
        itemBuilder: (context, index) {
          final item = accountItems[index];
          return Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: ListTile(
              leading: Icon(item['icon'], color: Colors.lightBlue),
              title: Text(item['label'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {}, // Add navigation or actions if needed
            ),
          );
        },
      ),
    );
  }
}
