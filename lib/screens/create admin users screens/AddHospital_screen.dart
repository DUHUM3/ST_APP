// import 'package:flutter/material.dart';
// import '../../../theme/color.dart';

// class HospitalOwnerRegisterScreen extends StatefulWidget {
//   @override
//   _HospitalOwnerRegisterScreenState createState() => _HospitalOwnerRegisterScreenState();
// }

// class _HospitalOwnerRegisterScreenState extends State<HospitalOwnerRegisterScreen> {
//   final _formKey = GlobalKey<FormState>();

//   String name = "";
//   String email = "";
//   String phone = "";
//   String hospitalName = "";
//   String location = "";
//   String password = "";

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('تسجيل مالك مستشفى'),
//         centerTitle: true,
//         backgroundColor: AppColors.background,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               _buildTextField(
//                 label: "الاسم الكامل",
//                 icon: Icons.person,
//                 onChanged: (value) => name = value,
//                 validator: (value) => value!.isEmpty ? "الرجاء إدخال الاسم" : null,
//               ),
//               _buildTextField(
//                 label: "البريد الإلكتروني",
//                 icon: Icons.email,
//                 keyboardType: TextInputType.emailAddress,
//                 onChanged: (value) => email = value,
//                 validator: (value) => !value!.contains('@') ? "بريد إلكتروني غير صالح" : null,
//               ),
//               _buildTextField(
//                 label: "رقم الهاتف",
//                 icon: Icons.phone,
//                 keyboardType: TextInputType.phone,
//                 onChanged: (value) => phone = value,
//                 validator: (value) => value!.length < 9 ? "رقم هاتف غير صالح" : null,
//               ),
//               _buildTextField(
//                 label: "اسم المستشفى",
//                 icon: Icons.local_hospital,
//                 onChanged: (value) => hospitalName = value,
//                 validator: (value) => value!.isEmpty ? "الرجاء إدخال اسم المستشفى" : null,
//               ),
//               _buildTextField(
//                 label: "موقع المستشفى",
//                 icon: Icons.location_on,
//                 onChanged: (value) => location = value,
//                 validator: (value) => value!.isEmpty ? "الرجاء إدخال الموقع" : null,
//               ),
//               _buildTextField(
//                 label: "كلمة المرور",
//                 icon: Icons.lock,
//                 obscureText: true,
//                 onChanged: (value) => password = value,
//                 validator: (value) => value!.length < 6 ? "كلمة المرور يجب أن تكون 6 أحرف على الأقل" : null,
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () {
//                   if (_formKey.currentState!.validate()) {
//                     // تنفيذ منطق التسجيل هنا
//                     print("تم التسجيل بنجاح!");
//                   }
//                 },
//                 style: ElevatedButton.styleFrom(
//                   padding: EdgeInsets.symmetric(vertical: 14),
//                   backgroundColor: AppColors.primaryColor,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 child: Text("تسجيل", style: TextStyle(fontSize: 18, color: Colors.white)),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField({
//     required String label,
//     required IconData icon,
//     TextInputType keyboardType = TextInputType.text,
//     bool obscureText = false,
//     required Function(String) onChanged,
//     required String? Function(String?) validator,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 15),
//       child: TextFormField(
//         keyboardType: keyboardType,
//         obscureText: obscureText,
//         onChanged: onChanged,
//         validator: validator,
//         decoration: InputDecoration(
//           labelText: label,
//           prefixIcon: Icon(icon, color: AppColors.primaryColor),
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//           focusedBorder: OutlineInputBorder(
//             borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
//             borderRadius: BorderRadius.circular(10),
//           ),
//         ),
//       ),
//     );
//   }
// }
