import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:st/screens/Settings%20Screens/login_screen.dart';
import 'firebase_options.dart';
import 'screens/Flights Screen/FlightBookingScreen.dart';
import 'screens/Hospitals Screens/hospitalHome_screen.dart';
import 'screens/Hotels Screens/hotel_screen.dart';
import 'screens/Reataurants Screens/restaurant_screen.dart';
import 'screens/Transportations Screens/transportationHome_screen.dart';
import 'screens/NavigateBar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// import 'providers/Controller.dart';
// import 'theme/ThemeService.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // تهيئة Firebase باستخدام الخيارات التي تم توليدها
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // final ThemeController themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
      return  GetMaterialApp(
        debugShowCheckedModeBanner: false,
        // theme: AppThemes.lightTheme,
        // darkTheme: AppThemes.darkTheme,
        // themeMode: themeController.theme,
        home: const HomePage(),
         routes: {
        '/flight_tickets': (context) => FlightBookingScreen(),
        '/hospitals': (context) => const HospitalsScreen(),
        '/hotels': (context) => const HotelsScreen(),
        '/restaurants': (context) => const RestaurantsScreen(),
        '/transportation': (context) => AvailableCarsScreen(),
        '/login': (context) => LoginScreen(),

      },
      );
    }
  }

