import 'package:flutter/material.dart';
import 'package:pokedex_flutter/widgets/popup_options/filter_section.dart';

class PopupOptionsForList extends StatefulWidget {
  final Function(Map<String, Set<String>>) onFiltersChanged;

  const PopupOptionsForList({super.key, required this.onFiltersChanged});

  @override
  State<PopupOptionsForList> createState() => _PopupOptionsForListState();
}

class _PopupOptionsForListState extends State<PopupOptionsForList> {
  final Map<String, Set<String>> selectedFilters = {
    'generations': {},
    'types': {},
  };

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
              FilterSection(
                title: "Generations",
                options: [
                  "Generation I",    // 1996 (Red, Blue, Yellow)
                  "Generation II",   // 1999 (Gold, Silver, Crystal)
                  "Generation III",  // 2002 (Ruby, Sapphire, Emerald)
                  "Generation IV",   // 2006 (Diamond, Pearl, Platinum)
                  "Generation V",    // 2010 (Black, White, Black 2, White 2)
                  "Generation VI",   // 2013 (X, Y, Omega Ruby, Alpha Sapphire)
                  "Generation VII",  // 2016 (Sun, Moon, Ultra Sun, Ultra Moon)
                  "Generation VIII", // 2019 (Sword, Shield, Brilliant Diamond, Shining Pearl)
                  "Generation IX",   // 2022 (Scarlet, Violet)
                ],
                onFilterChange: (filters) {
                  selectedFilters['generations'] = filters;
                  widget.onFiltersChanged(selectedFilters);
                },
              ),
              FilterSection(
                title: "Types",
                options: [
                  "Normal",
                  "Fire",
                  "Water",
                  "Electric",
                  "Grass",
                  "Ice",
                  "Fighting",
                  "Poison",
                  "Ground",
                  "Flying",
                  "Psychic",
                  "Bug",
                  "Rock",
                  "Ghost",
                  "Dragon",
                  "Dark",
                  "Steel",
                  "Fairy"
                ],
                onFilterChange: (filters) {
                  selectedFilters['types'] = filters;
                  widget.onFiltersChanged(selectedFilters);
                },
              ),
              FilterSection(
                title: "Abilities",
                options: [
                  "Overgrow",
                  "Chlorophyll",
                  "Blaze",
                  "Solar Power",
                  "Torrent",
                  "Rain Dish",
                  "Shield Dust",
                  "Run Away",
                  "Keen Eye",
                  "Intimidate",
                  "Static",
                  "Lightning Rod",
                ],
                onFilterChange: (filters) {
                  selectedFilters['cambiar esto'] = filters;
                  widget.onFiltersChanged(selectedFilters);
                },
              )
            ],
          ),
        ),
      ),

    );

  }
}
