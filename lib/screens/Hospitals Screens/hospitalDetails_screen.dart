import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../service/Hospital_service.dart'; // تأكد من أن المسار صحيح
import 'doctorDetails_screen.dart'; // تأكد من أن المسار صحيح

class HospitalDetailsScreen extends StatefulWidget {
  final String hospitalId;

  const HospitalDetailsScreen({super.key, required this.hospitalId});

  @override
  State<HospitalDetailsScreen> createState() => _HospitalDetailsScreenState();
}

class _HospitalDetailsScreenState extends State<HospitalDetailsScreen>
    with SingleTickerProviderStateMixin {
  int _currentImageIndex = 0;
  late TabController _tabController;
  bool isFavorite = false;
  Map<String, dynamic>? hospitalDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchHospitalDetails();
  }

  Future<void> _fetchHospitalDetails() async {
    if (!await _checkInternetConnection()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لا يوجد اتصال بالإنترنت')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final details = await ApiManager.getHospitalDetails(widget.hospitalId);
      if (details != null) {
        setState(() {
          hospitalDetails = details;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('لا توجد بيانات متاحة')),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل في تحميل بيانات المستشفى: $e')),
      );
    }
  }

  Future<bool> _checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (hospitalDetails == null) {
      return const Scaffold(
        body: Center(child: Text('فشل في تحميل بيانات المستشفى')),
      );
    }

final List<String> hospitalImages = hospitalDetails?['images'] ?? [
  'https://picsum.photos/600/400?random=1',
  'https://picsum.photos/600/400?random=2',
  'https://picsum.photos/600/400?random=3',
];

    return Directionality(
      textDirection: TextDirection.rtl, // تعيين اتجاه النص إلى RTL
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 300,
              floating: false,
              pinned: true,
              backgroundColor: Colors.red,
              iconTheme: const IconThemeData(color: Colors.white),
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
                                hospitalDetails?['name'] ?? 'اسم المستشفى',
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
                                      hospitalDetails?['address'] ?? 'عنوان المستشفى',
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
                      height: 500,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildOverviewTab(hospitalDetails),
                          _buildDoctorsTab(),
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
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [],
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
      ),
    );
  }

  Widget _buildOverviewTab(Map<String, dynamic>? hospitalDetails) {
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
            hospitalDetails?['description'] ?? 'وصف المستشفى',
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
            children: (hospitalDetails?['facilities'] as List<dynamic>? ?? []).map((amenity) {
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
  return FutureBuilder<List<dynamic>?>(
    future: ApiManager.getHospitalDoctors(widget.hospitalId),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }
      if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
        return Center(child: Text('لا توجد بيانات للأطباء'));
      }
      final doctors = snapshot.data!;
      return ListView.builder(
        itemCount: doctors.length,
        itemBuilder: (context, index) {
          final doctor = doctors[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(doctor['image'] ?? 'https://via.placeholder.com/150'),
            ),
            title: Text(doctor['name'] ?? 'اسم الطبيب'),
            subtitle: Text(doctor['specialty'] ?? 'التخصص'),
            onTap: () {
              // الانتقال إلى شاشة تفاصيل الطبيب
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DoctorDetailsScreen(doctorId: doctor['id']),
                ),
              );
            },
          );
        },
      );
    },
  );
}

  Widget _buildReviewsTab() {
    return FutureBuilder<Map<String, dynamic>?>(
      future: ApiManager.getHospitalReviews(widget.hospitalId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return Center(child: Text('لا توجد تقييمات متاحة'));
        }

        final reviewsData = snapshot.data!;
        final rating = reviewsData["averageRating"] ?? 0.0;
        final reviews = reviewsData["reviewsData"] ?? [];

        return Column(
          children: [
            RatingBar.builder(
              initialRating: rating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemSize: 30,
              ignoreGestures: true,
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {},
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _showAddReviewDialog(context);
              },
              child: Text('أضف تقييمك'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: reviews.length,
                itemBuilder: (context, index) {
                  final review = reviews[index];
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
                                      review['fullName'] ?? 'زائر',
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      DateTime.parse(review['createdAt']).toLocal().toString().split(' ')[0],
                                      style: GoogleFonts.poppins(
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              RatingBar.builder(
                                initialRating: review['rating']?.toDouble() ?? 0.0,
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
                            review['comment'] ?? 'لا يوجد تعليق',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void _showAddReviewDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    int _rating = 0;
    String _comment = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('أضف تقييمك', style: GoogleFonts.poppins()),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RatingBar.builder(
                  initialRating: 0,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 30,
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    _rating = rating.toInt();
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'تعليقك',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال تعليق';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _comment = value!;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('إلغاء', style: GoogleFonts.poppins(color: Colors.red)),
            ),
            TextButton(
              onPressed: () async {
                if (!await _checkInternetConnection()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('لا يوجد اتصال بالإنترنت')),
                  );
                  return;
                }
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  bool success = await ApiManager.addHospitalReview(
                    hospitalId: widget.hospitalId,
                    rating: _rating,
                    comment: _comment,
                  );
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('تم إضافة التقييم بنجاح!')),
                    );
                    Navigator.of(context).pop();
                    _fetchHospitalDetails(); // تحديث البيانات بعد الإضافة
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('فشل في إضافة التقييم')),
                    );
                  }
                }
              },
              child: Text('حفظ', style: GoogleFonts.poppins(color: Colors.green)),
            ),
          ],
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