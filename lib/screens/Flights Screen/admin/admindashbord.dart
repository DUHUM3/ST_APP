import 'package:flutter/material.dart';

import 'addFlightScreen.dart';

class AdminFlightsScreen extends StatelessWidget {
  const AdminFlightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة الرحلات'),
      ),
      body: const ResponsiveLayout(
        mobileLayout: MobileFlightsScreen(),
        tabletLayout: TabletFlightsScreen(),
        desktopLayout: DesktopFlightsScreen(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // إضافة رحلة جديدة
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddFlightScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class MobileFlightsScreen extends StatelessWidget {
  const MobileFlightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            FlightsList(),
          ],
        ),
      ),
    );
  }
}

class TabletFlightsScreen extends StatelessWidget {
  const TabletFlightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: FlightsList(),
          ),
          SizedBox(width: 16),
          Expanded(
            flex: 3,
            child: FlightDetailsPanel(),
          ),
        ],
      ),
    );
  }
}

class DesktopFlightsScreen extends StatelessWidget {
  const DesktopFlightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: FlightsList(),
          ),
          SizedBox(width: 16),
          Expanded(
            flex: 4,
            child: FlightDetailsPanel(),
          ),
          SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: QuickActionsPanel(),
          ),
        ],
      ),
    );
  }
}

class ResponsiveLayout extends StatelessWidget {
  final Widget mobileLayout;
  final Widget tabletLayout;
  final Widget desktopLayout;

  const ResponsiveLayout({super.key, 
    required this.mobileLayout,
    required this.tabletLayout,
    required this.desktopLayout,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return mobileLayout; // شاشة الهاتف
        } else if (constraints.maxWidth < 1200) {
          return tabletLayout; // شاشة الجهاز اللوحي
        } else {
          return desktopLayout; // شاشة الكمبيوتر
        }
      },
    );
  }
}

// Widgets مستخدمة في الشاشة
class FlightsList extends StatelessWidget {
  const FlightsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('قائمة الرحلات', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 10, // عدد الرحلات (يمكن استبدالها ببيانات حقيقية)
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('الرحلة #${index + 1}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('الوجهة: مدينة ${index + 1}'),
                      Text('حالة الرحلة: ${_getFlightStatus(index)}'),
                      Text('المقاعد المتبقية: ${_getRemainingSeats(index)}'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      // تعديل الرحلة
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AddFlightScreen()),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // دالة للحصول على حالة الرحلة
  String _getFlightStatus(int index) {
    List<String> statuses = ['نشطة', 'غير نشطة', 'ملغاة'];
    return statuses[index % statuses.length];
  }

  // دالة للحصول على عدد المقاعد المتبقية
  int _getRemainingSeats(int index) {
    List<int> seats = [50, 30, 10, 0, 100]; // بيانات وهمية
    return seats[index % seats.length];
  }
}

class FlightDetailsPanel extends StatelessWidget {
  const FlightDetailsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('تفاصيل الرحلة', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('رقم الرحلة: 123'),
            Text('الوجهة: مدينة 1'),
            Text('تاريخ الإقلاع: 2023-10-01'),
            Text('تاريخ الوصول: 2023-10-02'),
            Text('عدد المقاعد: 150'),
            Text('المقاعد المتبقية: 50'),
            Text('حالة الرحلة: نشطة'),
          ],
        ),
      ),
    );
  }
}

class QuickActionsPanel extends StatelessWidget {
  const QuickActionsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('إجراءات سريعة', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                // إضافة رحلة جديدة
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddFlightScreen()),
                );
              },
              child: const Text('إضافة رحلة'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                // تصدير البيانات
              },
              child: const Text('تصدير البيانات'),
            ),
          ],
        ),
      ),
    );
  }
}