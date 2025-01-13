import 'package:flutter/material.dart';

class FilterWidget extends StatefulWidget {
  final String initialDistance;
  final int initialGenderIndex;
  final double initialMinAge;
  final double initialMaxAge;
  final double initialMinBudget;
  final double initialMaxBudget;
  final void Function(String, int, double, double, double, double)? onApply;

  const FilterWidget({
    Key? key,
    required this.initialDistance,
    required this.initialGenderIndex,
    required this.initialMinAge,
    required this.initialMaxAge,
    required this.initialMinBudget,
    required this.initialMaxBudget,
    this.onApply,
  }) : super(key: key);

  @override
  _FilterWidgetState createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  late String _selectedDistance;
  late int _selectedGenderIndex;
  late double _minAge;
  late double _maxAge;
  late double _minBudget;
  late double _maxBudget;

  @override
  void initState() {
    super.initState();
    _selectedDistance = widget.initialDistance;
    _selectedGenderIndex = widget.initialGenderIndex;
    _minAge = widget.initialMinAge;
    _maxAge = widget.initialMaxAge;
    _minBudget = widget.initialMinBudget;
    _maxBudget = widget.initialMaxBudget;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Distance", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          DropdownButton<String>(
            value: _selectedDistance,
            isExpanded: true,
            items: [
              "0 km-10 km",
              "10 km-20 km",
              "20 km-30 km",
              "30 km-40 km",
              "40 km-50 km"
            ].map((String option) {
              return DropdownMenuItem<String>(
                value: option,
                child: Text(option),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedDistance = newValue!;
              });
            },
          ),

          // Gender Filter
          const SizedBox(height: 20),
          const Text("Gender", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Center(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(20),
              ),
              child: ToggleButtons(
                isSelected: [0, 1, 2].map((index) => index == _selectedGenderIndex).toList(),
                onPressed: (index) {
                  setState(() {
                    _selectedGenderIndex = index;
                  });
                },
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey,
                selectedColor: Colors.white,
                fillColor: const Color(0xFF9497B8),
                borderColor: Colors.transparent,
                selectedBorderColor: Colors.transparent,
                constraints: const BoxConstraints(
                  minHeight: 40,
                  minWidth: 90,
                ),
                children: const [
                  Text("Male"),
                  Text("Female"),
                  Text("Both"),
                ],
              ),
            ),
          ),

          // Age Filter
          const SizedBox(height: 20),
          const Text("Age", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Min: ${_minAge.round()}"),
              Text("Max: ${_maxAge.round()}"),
            ],
          ),
          RangeSlider(
            values: RangeValues(_minAge, _maxAge),
            min: 18,
            max: 60,
            divisions: 42,
            labels: RangeLabels("${_minAge.round()}", "${_maxAge.round()}"),
            activeColor: const Color(0xFF9497B8),
            inactiveColor: const Color(0xFF9497B8).withOpacity(0.3),
            onChanged: (values) {
              setState(() {
                _minAge = values.start;
                _maxAge = values.end;
              });
            },
          ),

          // Budget Filter
          const SizedBox(height: 20),
          const Text("Budget", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Min: \$${_minBudget.round()}"),
              Text("Max: \$${_maxBudget.round()}"),
            ],
          ),
          RangeSlider(
            values: RangeValues(_minBudget, _maxBudget),
            min: 500,
            max: 5000,
            divisions: 90,
            labels: RangeLabels("${_minBudget.round()}", "${_maxBudget.round()}"),
            activeColor: const Color(0xFF9497B8),
            inactiveColor: const Color(0xFF9497B8).withOpacity(0.3),
            onChanged: (values) {
              setState(() {
                _minBudget = values.start;
                _maxBudget = values.end;
              });
            },
          ),

          // Apply Button
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () {
                widget.onApply?.call(
                  _selectedDistance,
                  _selectedGenderIndex,
                  _minAge,
                  _maxAge,
                  _minBudget,
                  _maxBudget,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9497B8),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text("Apply Filters"),
            ),
          ),
        ],
      ),
    );
  }
}
