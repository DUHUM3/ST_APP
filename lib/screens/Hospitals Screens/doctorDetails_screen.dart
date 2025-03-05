import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:st/theme/color.dart';

import 'hospitalDetails_screen.dart';

class DoctorDetailsScreen extends StatelessWidget {
  final Doctor doctor;

  const DoctorDetailsScreen({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'تفاصيل الطبيب',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.red,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                backgroundImage: NetworkImage(doctor.image),
                radius: 80,
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                doctor.name,
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Center(
              child: Text(
                doctor.specialty,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 30),
            _buildDetailRow('التقييم', doctor.rating.toString(), Icons.star),
            _buildDetailRow('سنوات الخبرة', '${doctor.experience} سنوات', Icons.work),
            const SizedBox(height: 30),
            Text(
              'نبذة عن الطبيب',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'الدكتور ${doctor.name} هو أحد أفضل الأطباء في مجال ${doctor.specialty}، يتمتع بخبرة تزيد عن ${doctor.experience} سنوات. لديه سجل حافل بالإنجازات والمراجعات الإيجابية من المرضى.',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 30),
            Text(
              'المراجعات',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            _buildReviewCard('محمد علي', 'تجربة رائعة! الدكتور محترف جداً.', 4.5),
            _buildReviewCard('سارة أحمد', 'شرح واضح وعلاج فعال.', 5.0),
          ],
        ),
      ),
      // زر تقييم الطبيب
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            // فتح نموذج التقييم
            _showRatingDialog(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.red,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            'قيم الطبيب',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: AppColors.red, size: 24),
          const SizedBox(width: 10),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(String name, String review, double rating) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  child: const Icon(Icons.person),
                ),
                const SizedBox(width: 10),
                Text(
                  name,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                const Icon(Icons.star, color: Colors.amber, size: 20),
                const SizedBox(width: 5),
                Text(
                  rating.toString(),
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              review,
              style: GoogleFonts.poppins(
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // دالة لعرض نموذج التقييم مع تعليق
  void _showRatingDialog(BuildContext context) {
    double rating = 0;
    TextEditingController commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                'قيم الطبيب',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'كيف تقيم تجربتك مع الدكتور ${doctor.name}؟',
                    style: GoogleFonts.poppins(),
                  ),
                  const SizedBox(height: 20),
                  // النجوم للتقييم
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < rating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 30,
                        ),
                        onPressed: () {
                          setState(() {
                            rating = index + 1.0;
                          });
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: 20),
                  // حقل التعليق
                  TextField(
                    controller: commentController,
                    decoration: InputDecoration(
                      hintText: 'أضف تعليقك هنا...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'إلغاء',
                    style: GoogleFonts.poppins(
                      color: Colors.red,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // هنا يمكنك إرسال التقييم والتعليق إلى الخادم أو حفظه محليًا
                    print('التقييم: $rating');
                    print('التعليق: ${commentController.text}');
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'إرسال',
                    style: GoogleFonts.poppins(
                      color: AppColors.red,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}