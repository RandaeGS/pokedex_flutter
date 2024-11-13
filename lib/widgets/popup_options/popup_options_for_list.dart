import 'package:flutter/material.dart';
import 'package:pokedex_flutter/widgets/popup_options/FilterSection.dart';

class PopupOptionsForList extends StatefulWidget {
  const PopupOptionsForList({super.key});

  @override
  State<PopupOptionsForList> createState() => _PopupOptionsForListState();
}

class _PopupOptionsForListState extends State<PopupOptionsForList> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 12,
      backgroundColor: Colors.white,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FilterSection()
            ],
          ),
        ),
      ),

    );

  }
}
