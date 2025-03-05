import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../theme/color.dart';
import 'hotel_screen.dart';

class HotelDetailsScreen extends StatefulWidget {
  final Hotel hotel;

  const HotelDetailsScreen({super.key, required this.hotel});

  @override
  State<HotelDetailsScreen> createState() => _HotelDetailsScreenState();
}

class _HotelDetailsScreenState extends State<HotelDetailsScreen> with SingleTickerProviderStateMixin {
  int _currentImageIndex = 0;
  late TabController _tabController;
  bool isFavorite = false;
  List<Review> reviews = []; // قائمة لتخزين التقييمات

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

  void _addReview(Review review) {
    setState(() {
      reviews.add(review);
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<String> hotelImages = [
      widget.hotel.image,
      'https://picsum.photos/600/400?random=1',
      'https://picsum.photos/600/400?random=2',
      'https://picsum.photos/600/400?random=3',
    ];

    final List<Room> rooms = [
      Room(
        name: 'غرفة قياسية',
        image: 'https://picsum.photos/600/400?random=4',
        price: 150,
        description: 'غرفة مريحة مع سرير كوين.',
        amenities: ['واي فاي', 'تلفاز', 'تكييف'],
        availability: true,
      ),
      Room(
        name: 'غرفة ديلوكس',
        image: 'https://picsum.photos/600/400?random=5',
        price: 250,
        description: 'غرفة فسيحة مع سرير كينج وشرفة.',
        amenities: ['واي فاي', 'تلفاز', 'تكييف', 'ميني بار'],
        availability: true,
      ),
      Room(
        name: 'جناح',
        image: 'https://picsum.photos/600/400?random=6',
        price: 400,
        description: 'جناح فاخر مع منطقة معيشة وجاكوزي خاص.',
        amenities: ['واي فاي', 'تلفاز', 'تكييف', 'ميني بار', 'جاكوزي'],
        availability: false,
      ),
    ];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.orange,
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
                    items: hotelImages.map((image) {
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
                      children: hotelImages.asMap().entries.map((entry) {
                        return Container(
                          width: 8.0,
                          height: 8.0,
                          margin: const EdgeInsets.symmetric(horizontal: 4.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(
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
                  // تنفيذ مشاركة الفندق
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
                              widget.hotel.name,
                              style: GoogleFonts.cairo(
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
                                    widget.hotel.location,
                                    style: GoogleFonts.cairo(
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
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.orange,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'متاح للحجز',
                          style: GoogleFonts.cairo(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TabBar(
                    controller: _tabController,
                    labelColor: AppColors.orange,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: AppColors.orange,
                    tabs: const [
                      Tab(text: 'نظرة عامة'),
                      Tab(text: 'الغرف وا الاجنحه'),
                      Tab(text: 'المراجعات'),
                    ],
                  ),
                  SizedBox(
                    height: 500, // ارتفاع ثابت للمحتوى
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // نظرة عامة
                        _buildOverviewTab(widget.hotel),
                        // الغرف
                        _buildRoomsTab(rooms),
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
      Expanded(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'السعر يبدأ من',
              style: GoogleFonts.cairo(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            Text(
              '\$${widget.hotel.price}/ليلة',
              style: GoogleFonts.cairo(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.orange,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(width: 10), // مسافة بين الأزرار
      ElevatedButton(
        onPressed: () {
          _showAddReviewDialog(context); // فتح نموذج إضافة التقييم
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.orange.withOpacity(0.1), // لون خلفية شفاف
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          'قيم الفندق',
          style: GoogleFonts.cairo(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.orange, // لون النص برتقالي
          ),
        ),
      ),
      const SizedBox(width: 10), // مسافة بين الأزرار
      ElevatedButton(
        onPressed: () {
          // تنفيذ عملية الحجز
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.orange,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          'احجز الآن',
          style: GoogleFonts.cairo(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ],
  ),
),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     _showAddReviewDialog(context);
      //   },
      //   backgroundColor: AppColors.orange,
      //   child: const Icon(Icons.add, color: Colors.white),
      // ),
    );
  }

  void _showAddReviewDialog(BuildContext context) {
    double rating = 0;
    TextEditingController reviewController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'أضف تقييمك',
            style: GoogleFonts.cairo(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RatingBar.builder(
                initialRating: rating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 30,
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (value) {
                  rating = value;
                },
              ),
              const SizedBox(height: 20),
              TextField(
                controller: reviewController,
                decoration: InputDecoration(
                  hintText: 'اكتب تقييمك هنا...',
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
                Navigator.pop(context);
              },
              child: Text(
                'إلغاء',
                style: GoogleFonts.cairo(
                  color: Colors.grey,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                if (reviewController.text.isNotEmpty) {
                  _addReview(
                    Review(
                      userName: 'زائر جديد',
                      rating: rating,
                      comment: reviewController.text,
                      date: DateTime.now(),
                    ),
                  );
                  Navigator.pop(context);
                }
              },
              child: Text(
                'إضافة',
                style: GoogleFonts.cairo(
                  color: AppColors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildOverviewTab(Hotel hotel) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            'وصف الفندق',
            style: GoogleFonts.cairo(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            hotel.description,
            style: GoogleFonts.cairo(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'المرافق',
            style: GoogleFonts.cairo(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: hotel.amenities.map((amenity) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getAmenityIcon(amenity),
                      size: 20,
                      color: AppColors.orange,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      amenity,
                      style: GoogleFonts.cairo(
                        color: AppColors.orange,
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

  Widget _buildRoomsTab(List<Room> rooms) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: rooms.length,
      itemBuilder: (context, index) {
        final room = rooms[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 20),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                child: Image.network(
                  room.image,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          room.name,
                          style: GoogleFonts.cairo(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: room.availability
                                ? AppColors.orange.withOpacity(0.1)
                                : Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            room.availability ? 'متاح' : 'محجوز',
                            style: GoogleFonts.cairo(
                              color: room.availability ? AppColors.orange : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '\$${room.price}/ليلة',
                      style: GoogleFonts.cairo(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.orange,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      room.description,
                      style: GoogleFonts.cairo(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: room.amenities.map((amenity) {
                        return Chip(
                          label: Text(
                            amenity,
                            style: GoogleFonts.cairo(color: AppColors.orange),
                          ),
                          backgroundColor: AppColors.orange.withOpacity(0.1),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: room.availability ? () {} : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.orange,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          room.availability ? 'احجز الآن' : 'غير متاح',
                          style: GoogleFonts.cairo(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReviewsTab() {
    return ListView.builder(
      padding: EdgeInsets.zero,
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
                            review.userName,
                            style: GoogleFonts.cairo(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '${review.date.day}/${review.date.month}/${review.date.year}',
                            style: GoogleFonts.cairo(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    RatingBar.builder(
                      initialRating: review.rating,
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
                  review.comment,
                  style: GoogleFonts.cairo(
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

// نموذج التقييم
class Review {
  final String userName;
  final double rating;
  final String comment;
  final DateTime date;

  Review({
    required this.userName,
    required this.rating,
    required this.comment,
    required this.date,
  });
}

// تحديث نموذج الغرفة
class Room {
  final String name;
  final String image;
  final double price;
  final String description;
  final List<String> amenities;
  final bool availability;

  Room({
    required this.name,
    required this.image,
    required this.price,
    required this.description,
    required this.amenities,
    required this.availability,
  });
}