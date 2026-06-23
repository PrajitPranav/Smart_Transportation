import 'bus_model.dart';

class BookingStorage {
  static final BookingStorage _instance = BookingStorage._internal();
  factory BookingStorage() => _instance;
  BookingStorage._internal();

  final List<Bus> bookings = [];
}
