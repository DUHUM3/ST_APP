import 'package:flutter/material.dart';
import '../../service/flight_service.dart';
import '../../theme/color.dart';

class FlightBookingScreen extends StatefulWidget {
  final String flightId;

  const FlightBookingScreen({super.key, required this.flightId});

  @override
  State<FlightBookingScreen> createState() => _FlightBookingScreenState();
}

class _FlightBookingScreenState extends State<FlightBookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _seatNumberController = TextEditingController();
  final _passportNumberController = TextEditingController();
  String _selectedClass = 'Economy';
  bool _isLoading = false;

  final List<String> _classes = ['Economy', 'Business', 'FirstClass'];

  Future<void> _submitBooking() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final bookingData = {
        "flight": widget.flightId,
        "seatNumber": _seatNumberController.text,
        "class": _selectedClass,
        "price": _getPriceForClass(_selectedClass),
        "passportNumber": _passportNumberController.text,
      };

      try {
        await FlightService.bookFlight(bookingData);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم حجز الرحلة بنجاح!')),
        );
        Navigator.pop(context); // العودة إلى الشاشة السابقة
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('فشل في حجز الرحلة: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  double _getPriceForClass(String selectedClass) {
    switch (selectedClass) {
      case 'Economy':
        return 200;
      case 'Business':
        return 500;
      case 'FirstClass':
        return 1000;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('حجز الرحلة'),
          backgroundColor: AppColors.csstomblue,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _seatNumberController,
                  decoration: const InputDecoration(
                    labelText: 'رقم المقعد',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال رقم المقعد';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: _selectedClass,
                  items: _classes.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedClass = value!;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'الفئة السعرية',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passportNumberController,
                  decoration: const InputDecoration(
                    labelText: 'رقم الجواز',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال رقم الجواز';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Center(
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _submitBooking,
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
          ),
        ),
      ),
    );
  }
}
