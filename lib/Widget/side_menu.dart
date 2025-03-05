import 'package:flutter/material.dart';
import 'package:st/screens/create%20admin%20users%20screens/accountType_screen.dart';

// import '../screens/Flights Screen/admin/dashboard_screen.dart';
import '../screens/Flights Screen/admin/admindashbord.dart';
import '../screens/Settings Screens/changePassword_screen.dart';
import '../screens/Settings Screens/login_screen.dart';
import '../screens/Settings Screens/reservation_screen.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.green,
            ),
            child: Text(
              'القائمة الجانبية',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('اللغة'),
            onTap: () {
              // تنفيذ تغيير اللغة
               Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                       AccountTypeScreen(), // الانتقال إلى شاشة PatientSignUpScreen
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text(' انشاء حساب'),
            onTap: () {
              // الانتقال إلى شاشة الحساب
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                       LoginScreen(), // الانتقال إلى شاشة PatientSignUpScreen
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text('البروفايل'),
            onTap: () {
               Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                       AdminFlightsScreen(), // الانتقال إلى شاشة PatientSignUpScreen
                ),
              );// إغلاق القائمة الجانبية
            },
          ),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('تغيير كلمة المرور'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                       ChangePasswordScreen(), // الانتقال إلى شاشة PatientSignUpScreen
                ),
              );
            },
          ),
            ListTile(
            leading: const Icon(Icons.home_repair_service_sharp),
            title: const Text('الحجوزات'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                       const BookingsScreen(), // الانتقال إلى شاشة PatientSignUpScreen
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
