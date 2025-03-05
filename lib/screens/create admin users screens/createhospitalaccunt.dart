import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:st/theme/color.dart';

class HospitalRegistrationScreen extends StatefulWidget {
  const HospitalRegistrationScreen({super.key});

  @override
  _HospitalRegistrationScreenState createState() => _HospitalRegistrationScreenState();
}

class _HospitalRegistrationScreenState extends State<HospitalRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _hospitalNameController = TextEditingController();
  final TextEditingController _hospitalTypeController = TextEditingController();
  final TextEditingController _regionController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _managerNameController = TextEditingController();
  final TextEditingController _managerPositionController = TextEditingController();
  final TextEditingController _managerPhoneController = TextEditingController();
  final TextEditingController _managerEmailController = TextEditingController();

  File? _commercialRegisterImage;
  File? _medicalLicenseImage;
  File? _idOrPassportImage;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source, Function(File?) setImage) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        setImage(File(pickedFile.path));
      });
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.green), // تغيير لون الأيقونة إلى الأخضر
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
        validator: validator ?? (value) {
          if (value == null || value.isEmpty) {
            return 'يرجى إدخال $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildImagePicker(String title, File? image, Function(File?) setImage) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.green, // تغيير لون النص إلى الأخضر
            ),
          ),
          const SizedBox(height: 10),
          image == null
              ? InkWell(
                  onTap: () => _pickImage(ImageSource.gallery, setImage),
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.add_photo_alternate,
                              size: 40, color: Colors.green), // تغيير لون الأيقونة إلى الأخضر
                          const SizedBox(height: 8),
                          Text('اضغط لاختيار صورة',
                              style: TextStyle(color: Colors.grey[600])),
                        ],
                      ),
                    ),
                  ),
                )
              : Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        image,
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      right: 5,
                      top: 5,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () => setState(() => setImage(null)),
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:AppColors.background,
      appBar: AppBar(
        elevation: 0,
       
        backgroundColor: AppColors.background, // تغيير لون الشريط العلوي إلى الأخضر
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'معلومات المستشفى',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green, // تغيير لون النص إلى الأخضر
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _hospitalNameController,
                label: 'اسم المستشفى',
                icon: Icons.local_hospital,
              ),
              _buildTextField(
                controller: _hospitalTypeController,
                label: 'نوع المستشفى',
                icon: Icons.category,
              ),
              _buildTextField(
                controller: _regionController,
                label: 'المنطقة',
                icon: Icons.location_on,
              ),
              _buildTextField(
                controller: _phoneNumberController,
                label: 'رقم الهاتف',
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
              ),
              _buildTextField(
                controller: _emailController,
                label: 'البريد الإلكتروني',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 30),
              const Text(
                'معلومات المدير',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green, // تغيير لون النص إلى الأخضر
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _managerNameController,
                label: 'اسم المدير',
                icon: Icons.person,
              ),
              _buildTextField(
                controller: _managerPositionController,
                label: 'المنصب',
                icon: Icons.work,
              ),
              _buildTextField(
                controller: _managerPhoneController,
                label: 'رقم الهاتف',
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
              ),
              _buildTextField(
                controller: _managerEmailController,
                label: 'البريد الإلكتروني',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 30),
              const Text(
                'المستندات المطلوبة',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green, // تغيير لون النص إلى الأخضر
                ),
              ),
              const SizedBox(height: 20),
              _buildImagePicker(
                'صورة السجل التجاري',
                _commercialRegisterImage,
                (file) => _commercialRegisterImage = file,
              ),
              _buildImagePicker(
                'صورة الترخيص الطبي',
                _medicalLicenseImage,
                (file) => _medicalLicenseImage = file,
              ),
              _buildImagePicker(
                'صورة الهوية/جواز السفر',
                _idOrPassportImage,
                (file) => _idOrPassportImage = file,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Handle form submission
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('جاري إنشاء الحساب...')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    backgroundColor: Colors.green, // تغيير لون الخلفية إلى الأخضر
                  ),
                  child: const Text(
                    'طلب انشاء ',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}