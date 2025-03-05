import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AvailableCarsScreen extends StatelessWidget {
  final List<Car> cars = [
    Car(
      name: 'تويوتا كامري 2023',
      image: 'https://picsum.photos/300?random=1',
      price: 150,
      features: ['تكييف', 'واي فاي', 'ملاحة', 'مقاعد جلد'],
      isAvailable: true,
    ),
    Car(
      name: 'هيونداي سوناتا 2022',
      image: 'https://picsum.photos/300?random=2',
      price: 130,
      features: ['تكييف', 'واي فاي', 'ملاحة'],
      isAvailable: true,
    ),
    Car(
      name: 'نيسان ألتيما 2021',
      image: 'https://picsum.photos/300?random=3',
      price: 120,
      features: ['تكييف', 'واي فاي'],
      isAvailable: false,
    ),
    Car(
      name: 'فورد موستانج 2023',
      image: 'https://picsum.photos/300?random=4',
      price: 200,
      features: ['تكييف', 'واي فاي', 'ملاحة', 'مقاعد جلد', 'تحكم بالصوت'],
      isAvailable: true,
    ),
  ];

  AvailableCarsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'السيارات المتوفرة',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: cars.length,
        itemBuilder: (context, index) {
          final car = cars[index];
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
                    car.image,
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
                      Text(
                        car.name,
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '\$${car.price}/يوم',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: car.features.map((feature) {
                          return Chip(
                            label: Text(
                              feature,
                              style: GoogleFonts.poppins(
                                color: Colors.green,
                                fontSize: 12,
                              ),
                            ),
                            backgroundColor: Colors.green.withOpacity(0.1),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: car.isAvailable
                              ? () {
                                  // تنفيذ عملية الحجز
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('تم حجز ${car.name}'),
                                    ),
                                  );
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            car.isAvailable ? 'احجز الآن' : 'غير متاح',
                            style: GoogleFonts.poppins(
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
      ),
    );
  }
}

class Car {
  final String name;
  final String image;
  final double price;
  final List<String> features;
  final bool isAvailable;

  Car({
    required this.name,
    required this.image,
    required this.price,
    required this.features,
    this.isAvailable = true,
  });
}