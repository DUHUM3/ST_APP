import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart'; // لتنسيق التاريخ والوقت

import '../../service/Hospital_service.dart'; // تأكد من أن المسار صحيح

class DoctorDetailsScreen extends StatefulWidget {
  final String doctorId;

  const DoctorDetailsScreen({super.key, required this.doctorId});

  @override
  State<DoctorDetailsScreen> createState() => _DoctorDetailsScreenState();
}

class _DoctorDetailsScreenState extends State<DoctorDetailsScreen> {
  Map<String, dynamic>? doctorDetails;
  List<Map<String, dynamic>>? doctorSchedules;
  bool isLoading = true;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  @override
  void initState() {
    super.initState();
    _fetchDoctorDetails();
    _fetchDoctorSchedules();
  }

  Future<void> _fetchDoctorDetails() async {
    setState(() {
      isLoading = true;
    });

    try {
      final details = await ApiManager.getDoctorDetails(widget.doctorId);
      if (details != null) {
        setState(() {
          doctorDetails = details;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('لا توجد بيانات متاحة')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل في تحميل بيانات الطبيب: $e')),
      );
    }
  }

  Future<void> _fetchDoctorSchedules() async {
    try {
      final schedules = await ApiManager.getDoctorSchedules(widget.doctorId);
      if (schedules != null) {
        setState(() {
          doctorSchedules = schedules;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('لا توجد أوقات دوام متاحة')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل في تحميل أوقات الدوام: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  Future<void> _bookAppointment() async {
    if (selectedDate == null || selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء اختيار التاريخ والوقت')),
      );
      return;
    }

    final DateTime appointmentDateTime = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      selectedTime!.hour,
      selectedTime!.minute,
    );

    final String formattedDateTime = appointmentDateTime.toIso8601String();

    final String? errorMessage = await ApiManager.bookAppointment(
      doctorId: widget.doctorId,
      dateTime: formattedDateTime,
    );

    if (errorMessage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم حجز الموعد بنجاح')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (doctorDetails == null) {
      return const Scaffold(
        body: Center(child: Text('فشل في تحميل بيانات الطبيب')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(doctorDetails?['name'] ?? 'تفاصيل الطبيب'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(doctorDetails?['image'] ??
                      'https://via.placeholder.com/150'),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                doctorDetails?['name'] ?? 'اسم الطبيب',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                doctorDetails?['specialty'] ?? 'التخصص',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'سنوات الخبرة: ${doctorDetails?['experienceYears'] ?? 'غير معروف'}',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'رقم الهاتف: ${doctorDetails?['phoneNumber'] ?? 'غير معروف'}',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'السيرة الذاتية:',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                doctorDetails?['bio'] ?? 'لا يوجد وصف',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'التقييمات: ${doctorDetails?['averageRating'] ?? 0.0} (${doctorDetails?['totalReviews'] ?? 0} تقييمات)',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'أوقات الدوام:',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              if (doctorSchedules != null && doctorSchedules!.isNotEmpty)
                ...doctorSchedules!.map((schedule) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'من ${schedule['startDate']} إلى ${schedule['endDate']}',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'من ${schedule['startTime']} إلى ${schedule['endTime']}',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'مدة الموعد: ${schedule['slotDuration']} دقائق',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  );
                }).toList()
              else
                Text(
                  'لا توجد أوقات دوام متاحة',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                  ),
                ),
              const SizedBox(height: 20),
              Text(
                'حجز موعد:',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () => _selectDate(context),
                    child: Text(selectedDate == null
                        ? 'اختر التاريخ'
                        : DateFormat('yyyy-MM-dd').format(selectedDate!)),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => _selectTime(context),
                    child: Text(selectedTime == null
                        ? 'اختر الوقت'
                        : selectedTime!.format(context)),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _bookAppointment,
                  child: const Text('حجز الموعد'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
