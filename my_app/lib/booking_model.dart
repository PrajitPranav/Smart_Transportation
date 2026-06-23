class Booking {
  final String busName;
  final String from;
  final String to;
  final String arrival;
  final String departure;
  final String price;
  final String seats;
  final String type;
  final String driverName;
  final String number;

  Booking({
    required this.busName,
    required this.from,
    required this.to,
    required this.arrival,
    required this.departure,
    required this.price,
    required this.seats,
    required this.type,
    required this.driverName,
    required this.number,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      busName: json['bus_name'] ?? 'Unknown Bus',
      from: json['from'] ?? 'Unknown',
      to: json['to'] ?? 'Unknown',
      arrival: json['arrival'] ?? 'N/A',
      departure: json['departure'] ?? 'N/A',
      price: json['price']?.toString() ?? '0',
      seats: json['available seats']?.toString() ?? '0',
      type: json['type'] ?? 'Standard',
      driverName: json['driver_name'] ?? 'Unknown',
      number: json['number'] ?? 'N/A',
    );
  }
}
