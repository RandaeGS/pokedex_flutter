import 'package:flutter/material.dart';

class FilterSection extends StatefulWidget {
  const FilterSection({super.key});

  @override
  State<FilterSection> createState() => _FilterSectionState();
}

class _FilterSectionState extends State<FilterSection> {
  bool isExpanded = false;
  
  
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          child: Text("hola"),
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
        )
      ],
    );
  }
}
