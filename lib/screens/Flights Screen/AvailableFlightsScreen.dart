// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'flightDetail_screen.dart';
// import '../../theme/color.dart';

// class AvailableFlightsScreen extends StatelessWidget {
//   final String fromCity;
//   final String toCity;

//   const AvailableFlightsScreen({
//     super.key,
//     required this.fromCity,
//     required this.toCity,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: AppBar(
//         systemOverlayStyle: SystemUiOverlayStyle.dark,
//         title: const Text(
//           'الرحلات المتاحة',
//           style: TextStyle(
//             color: Colors.black,
//             fontWeight: FontWeight.bold,
//             fontSize: 22,
//           ),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.white,
//         elevation: 0,
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(
//             bottom: Radius.circular(20),
//           ),
//         ),
//         iconTheme: const IconThemeData(color: Colors.black),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildSectionTitle('نتائج البحث عن: $fromCity → $toCity'),
//             const SizedBox(height: 15),
//             _buildAvailableFlightsList(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSectionTitle(String title) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
//       decoration: const BoxDecoration(
//         border: Border(
//           right: BorderSide(
//             color: AppColors.csstomblue,
//             width: 4,
//           ),
//         ),
//       ),
//       child: Text(
//         title,
//         style: const TextStyle(
//           fontSize: 22,
//           fontWeight: FontWeight.bold,
//           color: AppColors.csstomblue,
//         ),
//       ),
//     );
//   }

//   Widget _buildAvailableFlightsList() {
//     return ListView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       itemCount: 3,
//       itemBuilder: (context, index) {
//         final flights = [
//           {
//             'city': 'صنعاء → القاهرة',
//             'country': 'رحلة مباشرة',
//             'details':
//                 'رحلة مباشرة من صنعاء إلى القاهرة. تشمل وجبة واحدة وتلفزيون شخصي.',
//           },
//           {
//             'city': 'عدن → الإسكندرية',
//             'country': 'رحلة مع توقف',
//             'details':
//                 'رحلة مع توقف واحد في القاهرة. تشمل وجبتين وتلفزيون شخصي.',
//           },
//           {
//             'city': 'تعز → شرم الشيخ',
//             'country': 'رحلة مباشرة',
//             'details':
//                 'رحلة مباشرة من تعز إلى شرم الشيخ. تشمل وجبة واحدة وتلفزيون شخصي.',
//           },
//         ];
//         return GestureDetector(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => FlightDetailScreen(
//                   city: flights[index]['city']!,
//                   country: flights[index]['country']!,
//                   price: '', // تمت إزالة السعر
//                   details: flights[index]['details']!,
//                 ),
//               ),
//             );
//           },
//           child: Container(
//             margin: const EdgeInsets.only(bottom: 15),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.1),
//                   spreadRadius: 2,
//                   blurRadius: 8,
//                   offset: const Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: ListTile(
//               contentPadding: const EdgeInsets.all(15),
//               leading: Container(
//                 width: 60,
//                 height: 60,
//                 decoration: BoxDecoration(
//                   color: Colors.grey[300],
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//               ),
//               title: Text(
//                 flights[index]['city']!,
//                 style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: AppColors.csstomblue,
//                 ),
//               ),
//               subtitle: Text(
//                 flights[index]['country']!,
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: Colors.grey[600],
//                 ),
//               ),
//               trailing: const Icon(
//                 Icons.arrow_forward_ios,
//                 color: AppColors.csstomblue,
//                 size: 20,
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }