import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'bus_model.dart';

class BusScreen extends StatefulWidget {
  const BusScreen({Key? key}) : super(key: key);

  @override
  State<BusScreen> createState() => _BusScreenState();
}

class _BusScreenState extends State<BusScreen> {
  List<Bus> busList = [];

  @override
  void initState() {
    super.initState();
    loadBusData();
  }

  Future<void> loadBusData() async {
    final String response = await rootBundle.loadString('assets/bus_data.json');
    final List<dynamic> data = jsonDecode(response);
    setState(() {
      busList = data.map((bus) => Bus.fromJson(bus)).toList();
    });
  }

  void showDetails(Bus bus) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(bus.busName),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("From: ${bus.from}"),
            Text("To: ${bus.to}"),
            Text("Departure: ${bus.departure}"),
            Text("Arrival: ${bus.arrival}"),
            Text("Available Seats: ${bus.availableSeats}"),
            Text("Price: ₹${bus.price}"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Available Buses")),
      body: ListView.builder(
        itemCount: busList.length,
        itemBuilder: (context, index) {
          final bus = busList[index];
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              title: Text(bus.busName),
              subtitle: Text("${bus.from} → ${bus.to}"),
              trailing: ElevatedButton(
                onPressed: () => showDetails(bus),
                child: const Text("Details"),
              ),
            ),
          );
        },
      ),
    );
  }
}
