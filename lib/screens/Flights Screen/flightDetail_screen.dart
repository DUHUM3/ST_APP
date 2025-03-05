import 'package:flutter/material.dart';
import '../../service/flight_service.dart';
import '../../theme/color.dart';
import 'BookingScreen.dart';

class FlightDetailScreen extends StatefulWidget {
  final String flightId;

  const FlightDetailScreen({super.key, required this.flightId});

  @override
  State<FlightDetailScreen> createState() => _FlightDetailScreenState();
}

class _FlightDetailScreenState extends State<FlightDetailScreen> {
  Map<String, dynamic>? _flightDetails;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchFlightDetails();
  }

  Future<void> _fetchFlightDetails() async {
    try {
      final data = await FlightService.fetchFlightDetails(widget.flightId);
      setState(() {
        _flightDetails = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load flight details';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('تفاصيل الرحلة'),
          backgroundColor: AppColors.csstomblue,
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
                ? Center(child: Text(_errorMessage!))
                : _flightDetails != null
                    ? SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFlightInfo(_flightDetails!),
                            const SizedBox(height: 20),
                            _buildPriceInfo(_flightDetails!),
                            const SizedBox(height: 20),
                            _buildSeatInfo(_flightDetails!),
                            const SizedBox(height: 30),
                            Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FlightBookingScreen(
                                        flightId: widget.flightId,
                                      ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.csstomblue,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 40,
                                    vertical: 15,
                                  ),
                                ),
                                child: const Text(
                                  'حجز الرحلة',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const Center(child: Text('لا توجد بيانات')),
      ),
    );
  }

  Widget _buildFlightInfo(Map<String, dynamic> flight) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('رقم الرحلة: ${flight['flightNumber']}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text('نوع الطائرة: ${flight['aircraftType']}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text('حالة الرحلة: ${flight['status']}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text('مطار المغادرة: ${flight['departureAirport']}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text('مطار الوصول: ${flight['arrivalAirport']}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text('وقت المغادرة: ${flight['departureTime']}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text('وقت الوصول: ${flight['arrivalTime']}', style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceInfo(Map<String, dynamic> flight) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'الفئات السعرية',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('الاقتصادية: \$${flight['priceEconomy']}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text('رجال الأعمال: \$${flight['priceBusiness']}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text('الأولى: \$${flight['priceFirstClass']}', style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildSeatInfo(Map<String, dynamic> flight) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('المقاعد المتاحة', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text('الاقتصادية: ${flight['availableSeatsEconomy']}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text('رجال الأعمال: ${flight['availableSeatsBusiness']}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text('الأولى: ${flight['availableSeatsFirstClass']}', style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
