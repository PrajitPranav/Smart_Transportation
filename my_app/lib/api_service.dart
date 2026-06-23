import 'dart:convert';
import 'package:http/http.dart' as http;
import 'bus_model.dart';

Future<List<Bus>> fetchBusData() async {
  final response = await http.get(Uri.parse('https://api.npoint.io/ba1d347db7ce24839f3e'));

  if (response.statusCode == 200) {
    List data = json.decode(response.body);
    return data.map((json) => Bus.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load bus data');
  }
}
