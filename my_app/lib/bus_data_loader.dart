import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

Future<List<Map<String, dynamic>>> loadBusData() async {
  final String response = await rootBundle.loadString('assets/bus_data.json');
  final data = jsonDecode(response);
  return List<Map<String, dynamic>>.from(data);
}
