import 'package:flutter/material.dart';

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
            pinned: true,

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
              title: Container(
                width: double.infinity,
                height: 40,
                color: Colors.white,
                child: const Center(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search"
                    ),
                  ),
                ),
              ),
            ),
          ),

          SliverGrid(

          )
        ],
      ),

    );
  }
}
