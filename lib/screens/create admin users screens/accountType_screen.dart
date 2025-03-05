import 'package:flutter/material.dart';
import '../../theme/color.dart';
import '../Settings Screens/createUser_screen.dart';
import '../Settings Screens/login_screen.dart';
import 'createFlightsaccunt.dart';
import 'createHotelaccunt.dart';
import 'createTransportationaccunt.dart';
import 'createhospitalaccunt.dart';
import 'createreataurantaccunt.dart';


class AccountTypeScreen extends StatelessWidget {
  final List<Map<String, dynamic>> accountTypes = [
    {'type': 'إنشاء حساب كمستخدم', 'icon': Icons.person, 'color': Colors.blue, 'screen': LoginScreen()},
    {'type': 'شركة طيران', 'icon': Icons.airplanemode_active, 'color': Colors.blueGrey, 'screen': AirlineRegistrationScreen()},
    {'type': 'مالك مستشفى', 'icon': Icons.local_hospital, 'color': Colors.green, 'screen': HospitalRegistrationScreen()},
    {'type': 'مالك فندق', 'icon': Icons.hotel, 'color': Colors.orange, 'screen': HotelRegistrationScreen()},
    {'type': 'صاحب مطعم', 'icon': Icons.restaurant, 'color': Colors.green, 'screen': RestaurantRegistrationScreen()},
    {'type': 'مالك سيارة', 'icon': Icons.directions_car, 'color': Colors.purple, 'screen': DriverRegistrationScreen()},
  ];

 AccountTypeScreen({super.key});

  void _onAccountTypeSelected(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.background,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 30),
            Expanded(
              child: ListView.separated(
                itemCount: accountTypes.length,
                separatorBuilder: (context, index) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () => _onAccountTypeSelected(context, accountTypes[index]['screen']),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: accountTypes[index]['color'].withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              accountTypes[index]['icon'],
                              color: accountTypes[index]['color'],
                              size: 30,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              accountTypes[index]['type'],
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 20),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
