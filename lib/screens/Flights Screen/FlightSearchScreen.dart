import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import '../../theme/color.dart';
import 'flightDetail_screen.dart'; // Ensure this path is correct for your project

class FlightSearchScreen extends StatefulWidget {
  const FlightSearchScreen({super.key});

  @override
  _FlightSearchScreenState createState() => _FlightSearchScreenState();
}

class _FlightSearchScreenState extends State<FlightSearchScreen> {
  final List<String> yemenCities = [
    "صنعاء", "عدن", "سيئون", "الحديدة", "القاهرة", "برج العرب",
    "شرم الشيخ", "الغردقة", "الأقصر", "أسوان", "مرسى علم",
    "طابا", "سوهاج", "أسيوط", "مطروح", "العريش", "أبو سمبل"
  ];

  final List<String> egyptCities = [
    "صنعاء", "عدن", "سيئون", "الحديدة", "القاهرة", "برج العرب",
    "شرم الشيخ", "الغردقة", "الأقصر", "أسوان", "مرسى علم",
    "طابا", "سوهاج", "أسيوط", "مطروح", "العريش", "أبو سمبل"
  ];

  String? fromCity;
  String? toCity;
  DateTime? departureDate;
  List<dynamic> flights = [];
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        title: const Text(
          'بحث عن رحلات',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildSearchSection(context),
            const SizedBox(height: 20),
            if (isLoading)
              const LinearProgressIndicator(
                backgroundColor: Colors.grey,
                color: AppColors.csstomblue,
              )
            else if (flights.isNotEmpty)
              _buildFlightsList()
            else if (!isLoading && flights.isEmpty)
              const Center(
                child: Text(
                  'لم يتم العثور على رحلات لهذا البحث',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 15,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'من',
              labelStyle: const TextStyle(
                  color: AppColors.csstomblue, fontWeight: FontWeight.w600),
              prefixIcon: const Icon(Icons.flight_takeoff,
                  color: AppColors.csstomblue, size: 22),
              filled: true,
              fillColor: Colors.grey[50],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.csstomblue, width: 2),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            ),
            items: yemenCities.map((city) {
              return DropdownMenuItem(
                value: city,
                child: Text(city),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                fromCity = value;
              });
            },
            hint: const Text('اختر مدينة يمنية'),
          ),
          const SizedBox(height: 15),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'إلى',
              labelStyle: const TextStyle(
                  color: AppColors.csstomblue, fontWeight: FontWeight.w600),
              prefixIcon: const Icon(Icons.flight_land,
                  color: AppColors.csstomblue, size: 22),
              filled: true,
              fillColor: Colors.grey[50],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.csstomblue, width: 2),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            ),
            items: egyptCities.map((city) {
              return DropdownMenuItem(
                value: city,
                child: Text(city),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                toCity = value;
              });
            },
            hint: const Text('اختر مدينة مصرية'),
          ),
          const SizedBox(height: 15),
          _buildSearchField(
            label: 'تاريخ المغادرة',
            icon: Icons.calendar_today,
            hint: 'اختر التاريخ',
            onTap: () async {
              final selectedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (selectedDate != null) {
                setState(() {
                  departureDate = selectedDate;
                });
              }
            },
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: () async {
                if (fromCity == null || toCity == null || departureDate == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('الرجاء اختيار مدينتي المغادرة والوصول وتاريخ المغادرة'),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else {
                  setState(() {
                    isLoading = true;
                  });

                  final formattedDate =
                      DateFormat('yyyy-MM-dd').format(departureDate!);
                  final url = Uri.parse(
                      'https://st-backend-si3x.onrender.com/flights/flights?departureAirport=$fromCity&arrivalAirport=$toCity&departureDate=$formattedDate');

                  final response = await http.get(url);

                  setState(() {
                    isLoading = false;
                  });

                  if (response.statusCode == 200) {
                    final List<dynamic> data = json.decode(response.body);
                    setState(() {
                      flights = data;
                    });
                  } else if (response.statusCode == 404) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('لم يتم العثور على رحلات لهذا البحث'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('خطأ في الخادم: ${response.statusCode}'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.csstomblue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 2,
              ),
              child: const Text(
                'ابحث عن رحلات',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  fromCity = null;
                  toCity = null;
                  departureDate = null;
                  flights = [];
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 2,
              ),
              child: const Text(
                'مسح البحث',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField({
    required String label,
    required IconData icon,
    required String hint,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          labelStyle:
              const TextStyle(color: AppColors.csstomblue, fontWeight: FontWeight.w600),
          prefixIcon: Icon(icon, color: AppColors.csstomblue, size: 22),
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
          filled: true,
          fillColor: Colors.grey[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.csstomblue, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
        enabled: false,
      ),
    );
  }

 Widget _buildFlightsList() {
  return ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: flights.length,
    itemBuilder: (context, index) {
      final flight = flights[index];
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 10),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          leading: const Icon(Icons.flight, color: AppColors.csstomblue),
          title: Text(
            'رقم الرحلة: ${flight['flightNumber'] ?? 'غير معروف'}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5),
              Text(
                'مطار المغادرة: ${flight['departureAirport'] ?? 'غير معروف'}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'السعر: \$${flight['priceEconomy'] ?? 'غير معروف'}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.green[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          trailing: const Icon(Icons.arrow_forward, color: AppColors.csstomblue),
          onTap: () {
            // الانتقال إلى شاشة التفاصيل عند النقر
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    FlightDetailScreen(flightId: flight["_id"]),
              ),
            );
          },
        ),
      );
    },
  );
}
}