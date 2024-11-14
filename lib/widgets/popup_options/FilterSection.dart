import 'package:flutter/material.dart';

class FilterSection extends StatefulWidget {
  final String title;
  final List<String> options;

  const FilterSection({
    super.key,
    required this.title,
    required this.options,
  });

  @override
  State<FilterSection> createState() => _FilterSectionState();
}

class _FilterSectionState extends State<FilterSection> {
  bool isExpanded = false;
  Set<String> selectedOptions = {};
  
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 6.0),
            child: Row(
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  isExpanded ? Icons.arrow_drop_up_sharp : Icons.arrow_drop_down_sharp
                )
              ],
            ),
          ),
        ),
        if(isExpanded)(
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Wrap(
                spacing: 8.0, // espacio horizontal entre chips
                runSpacing: 8.0, // espacio vertical entre filas
                children: widget.options.map((option) {
                  final isSelected = selectedOptions.contains(option);
                  return FilterChip(
                    label: Text(
                      option,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    selected: isSelected,
                    showCheckmark: false,
                    onSelected: (bool selected) {
                      setState(() {
                        if (selected) {
                          selectedOptions.add(option);
                        } else {
                          selectedOptions.remove(option);
                        }
                      });
                    },
                    selectedColor: Colors.blue, // Color cuando está seleccionado
                    backgroundColor: Colors.grey[200], // Color cuando no está seleccionado
                    checkmarkColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  );
                }).toList(),
              ),
            )),
      ],
    );
  }
}
