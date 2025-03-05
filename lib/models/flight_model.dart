// // lib/models/flight_model.dart

// class Flight {
//   final String id;
//   final String arrivalAirport;
//   final double priceEconomy;

//   Flight({
//     required this.id,
//     required this.arrivalAirport,
//     required this.priceEconomy,
//   });

//   // تحويل JSON إلى كائن Flight
//   factory Flight.fromJson(Map<String, dynamic> json) {
//     return Flight(
//       id: json['id'],
//       arrivalAirport: json['arrivalAirport'],
//       priceEconomy: json['priceEconomy'].toDouble(),
//     );
//   }

//   // تحويل كائن Flight إلى JSON (اختياري)
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'arrivalAirport': arrivalAirport,
//       'priceEconomy': priceEconomy,
//     };
//   }
// }