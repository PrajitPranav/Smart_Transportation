import 'package:flutter/material.dart';

class BusDetailsPage extends StatelessWidget {
  final Map bus;

  const BusDetailsPage({Key? key, required this.bus}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(bus['name'] ?? 'Bus Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Route: ${bus['route']}", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text("Seats Available: ${bus['seats']}", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text("Bus Type: ${bus['type']}", style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
