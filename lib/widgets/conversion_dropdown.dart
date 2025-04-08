import 'package:flutter/material.dart';

class ConversionDropdown extends StatelessWidget {
  final String label;
  final List<String> units;
  final ValueChanged<String?> onChanged;

  const ConversionDropdown({
    super.key,
    required this.label,
    required this.units,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          DropdownButton<String>(
            isExpanded: true,
            hint: Text(label),
            items:
                units.map((unit) {
                  return DropdownMenuItem<String>(
                    value: unit,
                    child: Text(unit),
                  );
                }).toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
