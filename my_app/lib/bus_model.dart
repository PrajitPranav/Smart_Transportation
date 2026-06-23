class Bus {
  final String from;
  final String to;
  final String busName;
  final String departure;
  final String arrival;
  final int price;
  final int availableSeats;

  Bus({
    required this.from,
    required this.to,
    required this.busName,
    required this.departure,
    required this.arrival,
    required this.price,
    required this.availableSeats,
  });

  factory Bus.fromJson(Map<String, dynamic> json) {
    return Bus(
      from: json['from'],
      to: json['to'],
      busName: json['bus_name'],
      departure: json['departure'],
      arrival: json['arrival'],
      price: json['price'],
      availableSeats: json['available_seats'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'from': from,
      'to': to,
      'bus_name': busName,
      'departure': departure,
      'arrival': arrival,
      'price': price,
      'available_seats': availableSeats,
    };
  }
}
