import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ConversionScreen extends StatefulWidget {
  final String category;

  const ConversionScreen({super.key, required this.category});

  @override
  State<ConversionScreen> createState() => _ConversionScreenState();
}

class _ConversionScreenState extends State<ConversionScreen> {
  final TextEditingController _inputController = TextEditingController();
  String? fromUnit;
  String? toUnit;
  String result = '';

  // Define units for each category
  final Map<String, List<String>> categoryUnits = {
    'Length': ['Meters', 'Kilometers', 'Miles', 'Feet', 'Inches'],
    'Weight': ['Kilograms', 'Grams', 'Pounds', 'Ounces'],
    'Temperature': ['Celsius', 'Fahrenheit', 'Kelvin'],
  };

  double convert(double value, String from, String to) {
    if (widget.category == 'Length') {
      // Convert everything to meters first
      double inMeters;
      switch (from) {
        case 'Meters':
          inMeters = value;
          break;
        case 'Kilometers':
          inMeters = value * 1000;
          break;
        case 'Miles':
          inMeters = value * 1609.34;
          break;
        case 'Feet':
          inMeters = value * 0.3048;
          break;
        case 'Inches':
          inMeters = value * 0.0254;
          break;
        default:
          return value;
      }

      // Convert meters to target unit
      switch (to) {
        case 'Meters':
          return inMeters;
        case 'Kilometers':
          return inMeters / 1000;
        case 'Miles':
          return inMeters / 1609.34;
        case 'Feet':
          return inMeters / 0.3048;
        case 'Inches':
          return inMeters / 0.0254;
        default:
          return inMeters;
      }
    }

    if (widget.category == 'Weight') {
      // Convert everything to grams first
      double inGrams;
      switch (from) {
        case 'Grams':
          inGrams = value;
          break;
        case 'Kilograms':
          inGrams = value * 1000;
          break;
        case 'Pounds':
          inGrams = value * 453.592;
          break;
        case 'Ounces':
          inGrams = value * 28.3495;
          break;
        default:
          return value;
      }

      // Convert grams to target unit
      switch (to) {
        case 'Grams':
          return inGrams;
        case 'Kilograms':
          return inGrams / 1000;
        case 'Pounds':
          return inGrams / 453.592;
        case 'Ounces':
          return inGrams / 28.3495;
        default:
          return inGrams;
      }
    }

    if (widget.category == 'Temperature') {
      // Temperature conversions
      if (from == to) return value;

      // Convert to Celsius first
      double inCelsius;
      switch (from) {
        case 'Celsius':
          inCelsius = value;
          break;
        case 'Fahrenheit':
          inCelsius = (value - 32) * 5 / 9;
          break;
        case 'Kelvin':
          inCelsius = value - 273.15;
          break;
        default:
          return value;
      }

      // Convert Celsius to target unit
      switch (to) {
        case 'Celsius':
          return inCelsius;
        case 'Fahrenheit':
          return (inCelsius * 9 / 5) + 32;
        case 'Kelvin':
          return inCelsius + 273.15;
        default:
          return inCelsius;
      }
    }

    return value;
  }

  void saveToHistory(double fromValue, double toValue) {
    FirebaseFirestore.instance.collection('conversions').add({
      'category': widget.category,
      'fromValue': fromValue,
      'fromUnit': fromUnit,
      'toValue': toValue,
      'toUnit': toUnit,
      'timestamp': DateTime.now(),
    });
  }

  String? _errorText;

  void _validateInput(String value) {
    setState(() {
      if (value.isEmpty) {
        _errorText = null;
        return;
      }

      if (double.tryParse(value) == null) {
        _errorText = 'Please enter a valid number';
      } else {
        _errorText = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.category} Converter'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _inputController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Enter value',
                border: const OutlineInputBorder(),
                errorText: _errorText,
              ),
              onChanged: _validateInput,
            ),
            const SizedBox(height: 20),
            DropdownButton<String>(
              value: fromUnit,
              hint: const Text('Convert from'),
              isExpanded: true,
              items:
                  categoryUnits[widget.category]!.map((String unit) {
                    return DropdownMenuItem<String>(
                      value: unit,
                      child: Text(unit),
                    );
                  }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  fromUnit = newValue;
                });
              },
            ),
            const SizedBox(height: 20),
            DropdownButton<String>(
              value: toUnit,
              hint: const Text('Convert to'),
              isExpanded: true,
              items:
                  categoryUnits[widget.category]!.map((String unit) {
                    return DropdownMenuItem<String>(
                      value: unit,
                      child: Text(unit),
                    );
                  }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  toUnit = newValue;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_inputController.text.isNotEmpty &&
                    fromUnit != null &&
                    toUnit != null &&
                    _errorText == null) {
                  // Add this condition
                  double inputValue = double.parse(_inputController.text);
                  double convertedValue = convert(
                    inputValue,
                    fromUnit!,
                    toUnit!,
                  );
                  setState(() {
                    result =
                        '${_inputController.text} $fromUnit = ${convertedValue.toStringAsFixed(2)} $toUnit';
                  });
                  saveToHistory(inputValue, convertedValue);
                }
              },
              child: const Text('Convert'),
            ),
            const SizedBox(height: 20),
            Text(
              result,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
