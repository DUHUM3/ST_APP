// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import '../../service/Hospital_service.dart';

// class BookAppointmentScreen extends StatefulWidget {
//   final String doctorId;

//   const BookAppointmentScreen({super.key, required this.doctorId});

//   @override
//   State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
// }

// class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
//   DateTime? selectedDate;
//   TimeOfDay? selectedTime;

// Future<void> _selectDate() async {
//   final DateTime? pickedDate = await showDatePicker(
//     context: context,
//     initialDate: DateTime.now(), // التاريخ الافتراضي الذي يظهر عند فتح التقويم
//     firstDate: DateTime.now(), // أول تاريخ يمكن اختياره (اليوم)
//     lastDate: DateTime(2025, 12, 31), // آخر تاريخ يمكن اختياره (نهاية عام 2025)
//   );

//   if (pickedDate != null && mounted) {
//     setState(() {
//       selectedDate = pickedDate;
//     });
//   }
// }


//   Future<void> _selectTime() async {
//     final TimeOfDay? pickedTime = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//     );

//     if (pickedTime != null) {
//       setState(() {
//         selectedTime = pickedTime;
//       });
//     }
//   }

//   Future<void> _bookAppointment() async {
//     if (selectedDate == null || selectedTime == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('الرجاء اختيار التاريخ والوقت')),
//       );
//       return;
//     }

//     final DateTime dateTime = DateTime(
//       selectedDate!.year,
//       selectedDate!.month,
//       selectedDate!.day,
//       selectedTime!.hour,
//       selectedTime!.minute,
//     );

//     final String formattedDateTime =
//         DateFormat("yyyy-MM-ddTHH:mm:ss").format(dateTime) + ".000Z";

//     final bool isBooked = await ApiManager.bookAppointment(
//       doctorId: widget.doctorId,
//       dateTime: formattedDateTime,
//     );

//     if (isBooked) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('تم حجز الموعد بنجاح')),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('فشل في حجز الموعد')),
//       );
//     }
//   }
// @override
// void initState() {
//   super.initState();
//   WidgetsBinding.instance.addPostFrameCallback((_) {
//     _selectDate(); // سيتم استدعاؤها بعد أن يصبح `context` جاهزًا
//   });
// }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('حجز موعد'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//           ElevatedButton(
//   onPressed: () async {
//     final DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime(2025),
//     );
//     if (pickedDate != null) {
//       print("تم اختيار التاريخ: $pickedDate");
//     }
//   },
//   child: const Text('اختر التاريخ'),
// ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _selectTime,
//               child: Text(
//                 selectedTime == null
//                     ? 'اختر الوقت'
//                     : 'الوقت المحدد: ${selectedTime!.format(context)}',
//               ),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _bookAppointment,
//               child: const Text('احجز الموعد'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
