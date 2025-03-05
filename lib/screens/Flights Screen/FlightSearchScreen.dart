import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'AvailableFlightsScreen.dart';
import '../../theme/color.dart';

class FlightSearchScreen extends StatelessWidget {
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

  FlightSearchScreen({super.key});

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
        child: _buildSearchSection(context),
      ),
    );
  }

  Widget _buildSearchSection(BuildContext context) {
    String? fromCity;
    String? toCity;

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
              fromCity = value;
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
              toCity = value;
            },
            hint: const Text('اختر مدينة مصرية'),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: _buildSearchField(
                  label: 'تاريخ المغادرة',
                  icon: Icons.calendar_today,
                  hint: 'اختر التاريخ',
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _buildSearchField(
                  label: 'عدد الركاب',
                  icon: Icons.person,
                  hint: 'اختر العدد',
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildCabinClassSection(),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: () {
                if (fromCity == null || toCity == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('الرجاء اختيار مدينتي المغادرة والوصول'),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else {
                  // Navigator.push(
                    // context,
                    // MaterialPageRoute(
                    //   builder: (context) => AvailableFlightsScreen(
                    //     fromCity: fromCity!,
                    //     toCity: toCity!,
                    //   ),
                    // ),
                  // );
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
        ],
      ),
    );
  }

  Widget _buildSearchField({
    required String label,
    required IconData icon,
    required String hint,
  }) {
    return TextFormField(
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
    );
  }

  Widget _buildCabinClassSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'فئة المقصورة',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.csstomblue,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildCabinClassButton(
                label: 'الاقتصادية',
                isSelected: true,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildCabinClassButton(
                label: 'رجال الأعمال',
                isSelected: false,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildCabinClassButton(
                label: 'الأولى',
                isSelected: false,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCabinClassButton({
    required String label,
    required bool isSelected,
  }) {
    return SizedBox(
      height: 45,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? AppColors.csstomblue : Colors.grey[100],
          elevation: isSelected ? 2 : 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : Colors.grey[600],
          ),
        ),
      ),
    );
  }
}