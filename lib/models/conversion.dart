class Conversion {
  final double value;
  final String fromUnit;
  final String toUnit;
  final double result;
  final String category;
  final DateTime timestamp;

  Conversion({
    required this.value,
    required this.fromUnit,
    required this.toUnit,
    required this.result,
    required this.category,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'value': value,
      'fromUnit': fromUnit,
      'toUnit': toUnit,
      'result': result,
      'category': category,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory Conversion.fromMap(Map<String, dynamic> map) {
    return Conversion(
      value: map['value'],
      fromUnit: map['fromUnit'],
      toUnit: map['toUnit'],
      result: map['result'],
      category: map['category'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}
