import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../service/TokenManager.dart';

class Booking {
  final String flightNumber;
  final String departureAirport;
  final String arrivalAirport;
  final String departureTime;
  final String arrivalTime;
  final String seatNumber;
  final String flightClass;
  final double price;
  final String passportNumber;
  final String status;

  Booking({
    required this.flightNumber,
    required this.departureAirport,
    required this.arrivalAirport,
    required this.departureTime,
    required this.arrivalTime,
    required this.seatNumber,
    required this.flightClass,
    required this.price,
    required this.passportNumber,
    required this.status,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      flightNumber: json['flight']['flightNumber'] ?? '',
      departureAirport: json['flight']['departureAirport'] ?? '',
      arrivalAirport: json['flight']['arrivalAirport'] ?? '',
      departureTime: json['flight']['departureTime'] ?? '',
      arrivalTime: json['flight']['arrivalTime'] ?? '',
      seatNumber: json['seatNumber'] ?? '',
      flightClass: json['class'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      passportNumber: json['passportNumber'] ?? '',
      status: json['status'] ?? '',
    );
  }
}

class BookingService {
  static const String baseUrl = "https://st-backend-si3x.onrender.com";

  static Future<List<Booking>> fetchUserBookings() async {
    String? accessToken = await TokenManager.getAccessToken();
    
    if (accessToken == null) {
      throw Exception('No access token found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/bookings/my-bookings'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Booking.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load bookings: ${response.body}');
    }
  }
}

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  _BookingsScreenState createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  List<Booking> bookings = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    try {
      final fetchedBookings = await BookingService.fetchUserBookings();
      setState(() {
        bookings = fetchedBookings;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ في تحميل الحجوزات: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String getStatusArabic(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return 'مؤكد';
      case 'pending':
        return 'قيد الانتظار';
      case 'cancelled':
        return 'ملغي';
      default:
        return status;
    }
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'حجوزاتي',
          style: GoogleFonts.cairo(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.orange,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
              ),
            )
          : bookings.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.flight_takeoff,
                          size: 80, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'لا توجد حجوزات حالياً',
                        style: GoogleFonts.cairo(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: bookings.length,
                  itemBuilder: (context, index) {
                    final booking = bookings[index];
                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.1),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.flight,
                                    color: Colors.orange, size: 24),
                                const SizedBox(width: 8),
                                Text(
                                  'رحلة رقم: ${booking.flightNumber}',
                                  style: GoogleFonts.cairo(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'من',
                                            style: GoogleFonts.cairo(
                                              color: Colors.grey[600],
                                              fontSize: 14,
                                            ),
                                          ),
                                          Text(
                                            booking.departureAirport,
                                            style: GoogleFonts.cairo(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Icon(Icons.arrow_forward,
                                        color: Colors.orange),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            'إلى',
                                            style: GoogleFonts.cairo(
                                              color: Colors.grey[600],
                                              fontSize: 14,
                                            ),
                                          ),
                                          Text(
                                            booking.arrivalAirport,
                                            style: GoogleFonts.cairo(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(height: 24),
                                _buildInfoRow(
                                  'وقت الإقلاع',
                                  booking.departureTime,
                                  Icons.access_time,
                                ),
                                _buildInfoRow(
                                  'رقم المقعد',
                                  booking.seatNumber,
                                  Icons.event_seat,
                                ),
                                _buildInfoRow(
                                  'السعر',
                                  '${booking.price} دولار',
                                  Icons.attach_money,
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: getStatusColor(booking.status)
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    getStatusArabic(booking.status),
                                    style: GoogleFonts.cairo(
                                      color: getStatusColor(booking.status),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text(
            '$label:',
            style: GoogleFonts.cairo(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: GoogleFonts.cairo(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}