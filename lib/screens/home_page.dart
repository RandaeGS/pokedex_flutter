import 'package:flutter/material.dart';
import '../widgets/list_pokemon.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text("Pokedex"),
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

                },
              )
            ],

            bottom: AppBar(
              backgroundColor: Colors.red,
              title: Container(
                width: double.infinity,
                height: 40,
                color: Colors.white,
                child: const Center(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search pokemon",
                      suffixIcon: Icon(Icons.search)
                    ),
                  ),
                ),
              ),
            ),
          ),

          const ListPokemon(),
        ],
      ),

    );
  }
}
