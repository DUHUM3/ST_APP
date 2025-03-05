import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:st/theme/color.dart';

class AirlineRegistrationScreen extends StatefulWidget {
  const AirlineRegistrationScreen({super.key});

  @override
  _AirlineRegistrationScreenState createState() => _AirlineRegistrationScreenState();
}

class _AirlineRegistrationScreenState extends State<AirlineRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _iataIcaoCodeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _officialEmailController = TextEditingController();
  final TextEditingController _officialPhoneController = TextEditingController();
  final TextEditingController _websiteUrlController = TextEditingController();
  final TextEditingController _headquartersAddressController = TextEditingController();
  final TextEditingController _operatingCountriesController = TextEditingController();
  final TextEditingController _registrationNumberController = TextEditingController();
  final TextEditingController _adminNameController = TextEditingController();
  final TextEditingController _adminEmailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  File? _companyLogoImage;
  File? _operatingLicenseImage;
  File? _legalDocumentsImage;
  File? _adminIdOrPassportImage; // صورة جواز السفر أو الهوية للمسؤول

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
          prefixIcon: Icon(icon, color: Colors.blue), // تغيير لون الأيقونة إلى الأزرق
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
              color: Colors.blue, // تغيير لون النص إلى الأزرق
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
                              size: 40, color: Colors.blue), // تغيير لون الأيقونة إلى الأزرق
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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.background, // تغيير لون الشريط العلوي إلى الأزرق
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'معلومات شركة الطيران',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue, // تغيير لون النص إلى الأزرق
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _companyNameController,
                label: 'اسم الشركة',
                icon: Icons.business,
              ),
              _buildTextField(
                controller: _iataIcaoCodeController,
                label: 'رمز IATA/ICAO',
                icon: Icons.code,
              ),
              _buildTextField(
                controller: _descriptionController,
                label: 'الوصف',
                icon: Icons.description,
              ),
              _buildImagePicker(
                'شعار الشركة',
                _companyLogoImage,
                (file) => _companyLogoImage = file,
              ),
              const SizedBox(height: 30),
              const Text(
                'معلومات الاتصال',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue, // تغيير لون النص إلى الأزرق
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _officialEmailController,
                label: 'البريد الإلكتروني الرسمي',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
              ),
              _buildTextField(
                controller: _officialPhoneController,
                label: 'رقم الهاتف الرسمي',
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
              ),
              _buildTextField(
                controller: _websiteUrlController,
                label: 'الموقع الإلكتروني',
                icon: Icons.language,
                keyboardType: TextInputType.url,
              ),
              _buildTextField(
                controller: _headquartersAddressController,
                label: 'عنوان المقر الرئيسي',
                icon: Icons.location_on,
              ),
              _buildTextField(
                controller: _operatingCountriesController,
                label: 'الدول والمدن التي تعمل بها',
                icon: Icons.map,
              ),
              const SizedBox(height: 30),
              const Text(
                'معلومات التسجيل والاعتماد',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue, // تغيير لون النص إلى الأزرق
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _registrationNumberController,
                label: 'رقم تسجيل الشركة',
                icon: Icons.assignment,
              ),
              _buildImagePicker(
                'الرخصة التشغيلية للطيران',
                _operatingLicenseImage,
                (file) => _operatingLicenseImage = file,
              ),
              _buildImagePicker(
                'الوثائق القانونية',
                _legalDocumentsImage,
                (file) => _legalDocumentsImage = file,
              ),
              const SizedBox(height: 30),
              const Text(
                'معلومات الحساب في النظام',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue, // تغيير لون النص إلى الأزرق
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _adminNameController,
                label: 'اسم مسؤول الحساب',
                icon: Icons.person,
              ),
              _buildTextField(
                controller: _adminEmailController,
                label: 'البريد الإلكتروني للمسؤول',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
              ),
              _buildTextField(
                controller: _passwordController,
                label: 'كلمة المرور',
                icon: Icons.lock,
                keyboardType: TextInputType.visiblePassword,
              ),
              _buildImagePicker(
                'صورة الهوية/جواز السفر للمسؤول',
                _adminIdOrPassportImage,
                (file) => _adminIdOrPassportImage = file,
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
                    backgroundColor: Colors.blue, // تغيير لون الخلفية إلى الأزرق
                  ),
                  child: const Text(
                    'طلب إنشاء',
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