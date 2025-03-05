import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'doctorDetails_screen.dart';
import 'hospitalHome_screen.dart';

class HospitalDetailsScreen extends StatefulWidget {
  final Hospital hospital;

  const HospitalDetailsScreen({super.key, required this.hospital});

  @override
  State<HospitalDetailsScreen> createState() => _HospitalDetailsScreenState();
}

class _HospitalDetailsScreenState extends State<HospitalDetailsScreen> with SingleTickerProviderStateMixin {
  int _currentImageIndex = 0;
  late TabController _tabController;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> hospitalImages = [
      widget.hospital.image,
      'https://picsum.photos/600/400?random=1',
      'https://picsum.photos/600/400?random=2',
      'https://picsum.photos/600/400?random=3',
    ];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
        SliverAppBar(
  expandedHeight: 300,
  floating: false,
  pinned: true,
  backgroundColor: Colors.red,
  iconTheme: const IconThemeData(color: Colors.white), // تغيير لون زر الرجوع إلى الأبيض
  flexibleSpace: FlexibleSpaceBar(
    background: Stack(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 400,
            autoPlay: true,
            enlargeCenterPage: false,
            viewportFraction: 1.0,
            onPageChanged: (index, reason) {
              setState(() {
                _currentImageIndex = index;
              });
            },
          ),
          items: hospitalImages.map((image) {
            return Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(image),
                  fit: BoxFit.cover,
                ),
              ),
            );
          }).toList(),
        ),
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: hospitalImages.asMap().entries.map((entry) {
              return Container(
                width: 8.0,
                height: 8.0,
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red.withOpacity(
                    _currentImageIndex == entry.key ? 0.9 : 0.4,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    ),
  ),
  actions: [
    IconButton(
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: Colors.white,
      ),
      onPressed: () {
        setState(() {
          isFavorite = !isFavorite;
        });
      },
    ),
    IconButton(
      icon: const Icon(Icons.share, color: Colors.white),
      onPressed: () {
        // تنفيذ مشاركة المستشفى
      },
    ),
  ],
),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.hospital.name,
                              style: GoogleFonts.poppins(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.location_on, color: Colors.grey, size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    widget.hospital.location,
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Container(
                      //   padding: const EdgeInsets.all(8),
                      //   decoration: BoxDecoration(
                      //     color: Colors.green,
                      //     borderRadius: BorderRadius.circular(12),
                      //   ),
                      //   child: Text(
                      //     'متاح للحجز',
                      //     style: GoogleFonts.poppins(
                      //       color: Colors.white,
                      //       fontWeight: FontWeight.bold,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TabBar(
                    controller: _tabController,
                    labelColor: Colors.red,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Colors.red,
                    tabs: const [
                      Tab(text: 'نظرة عامة'),
                      Tab(text: 'الأطباء'),
                      Tab(text: 'المراجعات'),
                    ],
                  ),
                  SizedBox(
                    height: 500, // ارتفاع ثابت للمحتوى
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // نظرة عامة
                        _buildOverviewTab(widget.hospital),
                        // الأطباء
                        _buildDoctorsTab(),
                        // المراجعات
                        _buildReviewsTab(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          children: [
            const Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text(
                  //   'السعر يبدأ من',
                  //   style: GoogleFonts.poppins(
                  //     color: Colors.grey,
                  //     fontSize: 14,
                  //   ),
                  // ),
                  // Text(
                  //   '\$${widget.hospital.price}/ليلة',
                  //   style: GoogleFonts.poppins(
                  //     fontSize: 24,
                  //     fontWeight: FontWeight.bold,
                  //     color: Colors.green,
                  //   ),
                  // ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // تنفيذ عملية الحجز
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'احجز الآن',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTab(Hospital hospital) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            'وصف المستشفى',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            hospital.description,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'المرافق',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: hospital.amenities.map((amenity) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getAmenityIcon(amenity),
                      size: 20,
                      color: Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      amenity,
                      style: GoogleFonts.poppins(
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

 Widget _buildDoctorsTab() {
  final List<Doctor> doctors = [
    Doctor(
      name: 'د. أحمد محمد',
      specialty: 'جراحة عامة',
      image: 'https://picsum.photos/100?random=1',
      rating: 4.8,
      experience: 10,
    ),
    Doctor(
      name: 'د. سارة علي',
      specialty: 'طب الأطفال',
      image: 'https://picsum.photos/100?random=2',
      rating: 4.9,
      experience: 8,
    ),
    Doctor(
      name: 'د. خالد حسن',
      specialty: 'أمراض القلب',
      image: 'https://picsum.photos/100?random=3',
      rating: 4.7,
      experience: 12,
    ),
  ];

  return ListView.builder(
    padding: EdgeInsets.zero,
    itemCount: doctors.length,
    itemBuilder: (context, index) {
      final doctor = doctors[index];
      return Card(
        margin: const EdgeInsets.only(bottom: 20),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(doctor.image),
                radius: 40,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctor.name,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      doctor.specialty,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          doctor.rating.toString(),
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Icon(Icons.work, color: Colors.grey, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${doctor.experience} سنوات خبرة',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // زر "زيارة"
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DoctorDetailsScreen(doctor: doctor),
                    ),
                  );
                },
                icon: const Icon(Icons.arrow_forward, color: Colors.red),
              ),
            ],
          ),
        ),
      );
    },
  );
}

  Widget _buildReviewsTab() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: 5,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 15),
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
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'زائر ${index + 1}',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '${DateTime.now().subtract(Duration(days: index)).day}/${DateTime.now().month}/${DateTime.now().year}',
                            style: GoogleFonts.poppins(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    RatingBar.builder(
                      initialRating: 4.5,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 20,
                      ignoreGestures: true,
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {},
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'تجربة رائعة! المستشفى نظيف جداً والخدمة ممتازة. الموقع مثالي وقريب من كل شيء.',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  IconData _getAmenityIcon(String amenity) {
    switch (amenity.toLowerCase()) {
      case 'wifi':
      case 'واي فاي':
        return Icons.wifi;
      case 'tv':
      case 'تلفاز':
        return Icons.tv;
      case 'air conditioning':
      case 'تكييف':
        return Icons.ac_unit;
      case 'mini bar':
      case 'ميني بار':
        return Icons.local_bar;
      default:
        return Icons.check_circle;
    }
  }
}

class Doctor {
  final String name;
  final String specialty;
  final String image;
  final double rating;
  final int experience;

  Doctor({
    required this.name,
    required this.specialty,
    required this.image,
    required this.rating,
    required this.experience,
  });
}