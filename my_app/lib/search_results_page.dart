import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'bus_model.dart';
import 'booking_storage.dart';

class SearchResultsPage extends StatefulWidget {
  const SearchResultsPage({super.key});

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  List<Bus> allBuses = [];
  List<Bus> filteredBuses = [];
  List<bool> isExpanded = [];

  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadBusData();
  }

  Future<void> loadBusData() async {
    final String response = await rootBundle.loadString('assets/bus_data.json');
    final List<dynamic> data = json.decode(response);

    setState(() {
      allBuses = data.map((bus) => Bus.fromJson(bus)).toList();
      filteredBuses = [];
      isExpanded = [];
    });
  }

  void searchBuses() {
    String from = fromController.text.trim().toLowerCase();
    String to = toController.text.trim().toLowerCase();

    final results = allBuses.where((bus) {
      return bus.from.toLowerCase().contains(from) &&
             bus.to.toLowerCase().contains(to);
    }).toList();

    setState(() {
      filteredBuses = results;
      isExpanded = List<bool>.filled(results.length, false);
    });
  }

  void _bookBus(Bus bus) {
    BookingStorage().bookings.add(bus);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Bus booked successfully!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Search Buses")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                TextField(
                  controller: fromController,
                  decoration: const InputDecoration(labelText: "From"),
                ),
                TextField(
                  controller: toController,
                  decoration: const InputDecoration(labelText: "To"),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: searchBuses,
                  child: const Text("Search Buses"),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: filteredBuses.isEmpty
                ? const Center(child: Text("No buses found."))
                : ListView.builder(
                    itemCount: filteredBuses.length,
                    itemBuilder: (context, index) {
                      final bus = filteredBuses[index];
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
                              Text("From: ${bus.from}"),
                              Text("To: ${bus.to}"),
                              Text("Departure: ${bus.departure}"),
                              Text("Arrival: ${bus.arrival}"),
                              Text("Price: ₹${bus.price}"),
                              Text("Available Seats: ${bus.availableSeats}"),
                              AnimatedCrossFade(
                                firstChild: const SizedBox.shrink(),
                                secondChild: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Divider(),
                                    ElevatedButton(
                                      onPressed: () => _bookBus(bus),
                                      child: const Text("Book Now"),
                                    ),
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
          ),
        ],
      ),
    );
  }
}
