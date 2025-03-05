import 'package:flutter/material.dart';

class AddFlightScreen extends StatefulWidget {
  const AddFlightScreen({super.key});

  @override
  _AddFlightScreenState createState() => _AddFlightScreenState();
}

class _AddFlightScreenState extends State<AddFlightScreen> {
  final _formKey = GlobalKey<FormState>();

  // تعريف المتغيرات
  String _flightNumber = '';
  String _flightType = 'ذهاب فقط'; // قيمة افتراضية
  String _departureAirport = '';
  String _aircraftType = '';
  String _arrivalAirport = '';
  int _totalSeats = 0;
  DateTime _departureDateTime = DateTime.now();
  DateTime _arrivalDateTime = DateTime.now();
  bool _allowExtraBaggage = false;
  final Map<String, int> _seatClasses = {};
  final Map<String, double> _seatPrices = {};
  double _additionalFees = 0.0;
  double _extraBaggagePrice = 0.0;
  bool _specialServices = false;
  bool _isActive = true;
  bool _allowCancellation = false;

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required void Function(String?) onSaved,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    String? hintText,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.grey[50],
        ),
        keyboardType: keyboardType,
        onSaved: onSaved,
        validator: validator,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إضافة رحلة جديدة'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
        ),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // بطاقة معلومات الرحلة الأساسية
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('معلومات الرحلة الأساسية'),
                      _buildTextField(
                        label: 'رقم الرحلة',
                        onSaved: (value) => _flightNumber = value!,
                        validator: (value) =>
                            value!.isEmpty ? 'يرجى إدخال رقم الرحلة' : null,
                        hintText: 'مثال: FZ123',
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _flightType,
                        decoration: InputDecoration(
                          labelText: 'نوع الرحلة',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                        items: ['ذهاب فقط', 'ذهاب وعودة', 'متعددة الوجهات']
                            .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (value) =>
                            setState(() => _flightType = value!),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // بطاقة معلومات المسار
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('معلومات المسار'),
                      _buildTextField(
                        label: 'مطار الإقلاع',
                        onSaved: (value) => _departureAirport = value!,
                        validator: (value) =>
                            value!.isEmpty ? 'يرجى إدخال مطار الإقلاع' : null,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        label: 'مطار الوصول',
                        onSaved: (value) => _arrivalAirport = value!,
                        validator: (value) =>
                            value!.isEmpty ? 'يرجى إدخال مطار الوصول' : null,
                      ),
                      const SizedBox(height: 16),
                      Card(
                        color: Colors.blue[50],
                        child: ListTile(
                          leading: const Icon(Icons.flight_takeoff),
                          title: const Text('تاريخ ووقت الإقلاع'),
                          subtitle: Text(_departureDateTime.toString()),
                          onTap: () async {
                            final selectedDate = await showDatePicker(
                              context: context,
                              initialDate: _departureDateTime,
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100),
                            );
                            if (selectedDate != null) {
                              setState(() => _departureDateTime = selectedDate);
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      Card(
                        color: Colors.blue[50],
                        child: ListTile(
                          leading: const Icon(Icons.flight_land),
                          title: const Text('تاريخ ووقت الوصول'),
                          subtitle: Text(_arrivalDateTime.toString()),
                          onTap: () async {
                            final selectedDate = await showDatePicker(
                              context: context,
                              initialDate: _arrivalDateTime,
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100),
                            );
                            if (selectedDate != null) {
                              setState(() => _arrivalDateTime = selectedDate);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // بطاقة معلومات الطائرة والمقاعد
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('معلومات الطائرة والمقاعد'),
                      _buildTextField(
                        label: 'نوع الطائرة',
                        onSaved: (value) => _aircraftType = value!,
                        validator: (value) =>
                            value!.isEmpty ? 'يرجى إدخال نوع الطائرة' : null,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        label: 'إجمالي عدد المقاعد',
                        keyboardType: TextInputType.number,
                        onSaved: (value) => _totalSeats = int.parse(value!),
                        validator: (value) =>
                            value!.isEmpty ? 'يرجى إدخال عدد المقاعد' : null,
                      ),
                      const SizedBox(height: 16),
                      ..._seatClasses.keys.map((key) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: _buildTextField(
                            label: 'عدد مقاعد $key',
                            keyboardType: TextInputType.number,
                            onSaved: (value) =>
                                _seatClasses[key] = int.parse(value!),
                            validator: (value) => value!.isEmpty
                                ? 'يرجى إدخال عدد المقاعد'
                                : null,
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // بطاقة الأسعار والتكاليف
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('الأسعار والتكاليف'),
                      ..._seatPrices.keys.map((key) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: _buildTextField(
                            label: 'سعر $key',
                            keyboardType: TextInputType.number,
                            onSaved: (value) =>
                                _seatPrices[key] = double.parse(value!),
                            validator: (value) =>
                                value!.isEmpty ? 'يرجى إدخال السعر' : null,
                          ),
                        );
                      }),
                      _buildTextField(
                        label: 'الضرائب والرسوم الإضافية',
                        keyboardType: TextInputType.number,
                        onSaved: (value) =>
                            _additionalFees = double.parse(value!),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // بطاقة الخدمات الإضافية
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('الخدمات الإضافية'),
                      Card(
                        color: Colors.grey[50],
                        child: SwitchListTile(
                          title: const Text('إمكانية شحن الأمتعة الإضافية'),
                          value: _allowExtraBaggage,
                          onChanged: (value) =>
                              setState(() => _allowExtraBaggage = value),
                        ),
                      ),
                      if (_allowExtraBaggage) ...[
                        const SizedBox(height: 16),
                        _buildTextField(
                          label: 'سعر الأمتعة الإضافية',
                          keyboardType: TextInputType.number,
                          onSaved: (value) =>
                              _extraBaggagePrice = double.parse(value!),
                        ),
                      ],
                      const SizedBox(height: 16),
                      Card(
                        color: Colors.grey[50],
                        child: CheckboxListTile(
                          title:
                              const Text('خدمات خاصة (ذوي الاحتياجات الخاصة)'),
                          value: _specialServices,
                          onChanged: (value) =>
                              setState(() => _specialServices = value!),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // بطاقة حالة الرحلة
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('حالة الرحلة'),
                      Card(
                        color: Colors.grey[50],
                        child: SwitchListTile(
                          title: Text(
                              'حالة الرحلة: ${_isActive ? 'نشطة' : 'غير نشطة'}'),
                          value: _isActive,
                          onChanged: (value) =>
                              setState(() => _isActive = value),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Card(
                        color: Colors.grey[50],
                        child: SwitchListTile(
                          title: Text(
                              'إمكانية الإلغاء: ${_allowCancellation ? 'مسموح' : 'غير مسموح'}'),
                          value: _allowCancellation,
                          onChanged: (value) =>
                              setState(() => _allowCancellation = value),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // أزرار الحفظ والإلغاء
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.save),
                        label: const Text('حفظ الرحلة'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            // حفظ الرحلة
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.cancel),
                        label: const Text('إلغاء'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
