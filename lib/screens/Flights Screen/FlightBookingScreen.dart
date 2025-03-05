import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../service/flight_service.dart';
import 'FlightSearchScreen.dart';
import 'flightDetail_screen.dart';
import '../../theme/color.dart';

class FlightBookingScreen extends StatelessWidget {
  const FlightBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // تحديد الاتجاه من اليمين إلى اليسار
      child: Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              backgroundColor: AppColors.csstomblue,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text(
                  'اكتشف العالم',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            AppColors.csstomblue,
                            AppColors.csstomblue.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      right: 20,
                      bottom: 60,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'رحلات مميزة بأسعار تنافسية',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications_none),
                  onPressed: () {},
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildSearchBox(context),
                    const SizedBox(height: 25),
                    _buildQuickActions(),
                    const SizedBox(height: 25),
                    _buildPopularFlights(context),
                    const SizedBox(height: 25),
                    _buildSpecialDeals(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBox(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FlightSearchScreen()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue[50]!,
              Colors.blue[100]!,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 15,
            ),
          ],
        ),
        child: const Row(
          children: [
            Icon(
              Icons.flight_takeoff,
              color: AppColors.csstomblue,
              size: 30,
            ),
            SizedBox(width: 15),
            Text(
              'إلى أين تود السفر؟',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      {'icon': Icons.flight, 'title': 'رحلات'},
      {'icon': Icons.hotel, 'title': 'فنادق'},
      {'icon': Icons.directions_car, 'title': 'سيارات'},
      {'icon': Icons.card_giftcard, 'title': 'عروض'},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: actions.map((action) {
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Icon(
                action['icon'] as IconData,
                color: AppColors.csstomblue,
                size: 30,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              action['title']! as String,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildPopularFlights(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: FlightService.fetchFlights(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text("فشل في تحميل البيانات"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("لا توجد رحلات متاحة"));
        }

        final flights = snapshot.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'الرحلات المتوفرة',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: flights.length,
                itemBuilder: (context, index) {
                  final flight = flights[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              FlightDetailScreen(flightId: flight["id"]),
                        ),
                      );
                    },
                    child: Container(
                      width: 160,
                      margin: const EdgeInsets.only(left: 15),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'وجهة: ${flight["arrivalAirport"]}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'أرخص فئة: \$${flight["priceEconomy"]}',
                            style: const TextStyle(
                              color: Colors.white,
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

  Widget _buildSpecialDeals(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: FlightService.fetchDiscountedFlights(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text("فشل في تحميل العروض الخاصة"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("لا توجد عروض خاصة متاحة"));
        }

        final discountedFlights = snapshot.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'عروض خاصة',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: discountedFlights.length,
              itemBuilder: (context, index) {
                final flight = discountedFlights[index];

                return GestureDetector(
                  onTap: () {
                    // الانتقال إلى شاشة التفاصيل عند النقر
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            FlightDetailScreen(flightId: flight["id"]),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.blue[100],
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Icon(
                              Icons.flight,
                              color: AppColors.csstomblue,
                              size: 40,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'خصم ${flight["discount"]}%',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.csstomblue,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'إلى ${flight["arrivalAirport"]}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'السعر: \$${flight["priceEconomy"]}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.csstomblue,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Text(
                              'احجز الآن',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
