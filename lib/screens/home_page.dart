import 'package:flutter/material.dart';
import 'package:pokedex_flutter/widgets/popup_options/popup_options_for_list.dart';
import '../widgets/list_pokemon.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, Set<String>> activeFilters = {
    'generations': {},
    'types': {},
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text("Pokedex",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 27

              ),
            ),
            backgroundColor: Colors.red,
            floating: true,
            pinned: true,
            snap: true,
            centerTitle: false,

            actions: [
              IconButton(
                icon: const Icon(Icons.filter_list),
                color: Colors.white,
                tooltip: "Filter",
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return PopupOptionsForList(
                        currentFilters: activeFilters,
                        onFiltersChanged: (filters) {
                          setState(() {
                            activeFilters = filters;
                          });
                        },
                      );
                    },
                  );
                },
              )
            ],

            bottom: AppBar(
              backgroundColor: Colors.red,
              title: Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search",
                      hintStyle: TextStyle(color: Colors.grey),
                      suffixIcon: Icon(Icons.search),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10)
                    ),
                  ),
                ),
              ),
            ),

          ),

          ListPokemon(activeFilters: activeFilters,),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ,
        tooltip: "Options",
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
