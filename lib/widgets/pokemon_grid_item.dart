import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PokemonGridItem extends StatelessWidget {
  final dynamic pokemon;

  const PokemonGridItem({
    super.key,
    required this.pokemon,
  });

  @override
  Widget build(BuildContext context) {

    final number = pokemon['id'];
    final name = pokemon['name'];
    final types = (pokemon['pokemon_v2_pokemontypes'] as List)
        .map((type) => type['pokemon_v2_type']['name'])
        .toList();
    final spriteUrl = pokemon['pokemon_v2_pokemonsprites'][0]['sprites'];

    String formatPokemonNumber(int number) {
      return '#${number.toString().padLeft(3, '0')}';
    }

    List<Color> getTypeColors(String type) {
      final typeColors = {
        'fire': [Colors.red, Colors.orange],
        'water': [Colors.blue, Colors.lightBlue],
        'grass': [Colors.green, Colors.lightGreen],
        'electric': [Colors.yellow, Colors.amber],
        'normal': [Colors.grey, Colors.blueGrey],
        'bug': [Colors.green, Colors.lime],
        'poison': [Colors.purple, Colors.deepPurple],
        'ground': [Colors.brown, Colors.orange],
        'flying': [Colors.blue, Colors.indigo],
        'fighting': [Colors.red, Colors.brown],
        'psychic': [Colors.pink, Colors.purple],
        'rock': [Colors.brown, Colors.grey],
        'ghost': [Colors.purple, Colors.indigo],
        'dragon': [Colors.indigo, Colors.deepPurple],
        'dark': [Colors.brown, Colors.grey],
        'steel': [Colors.grey, Colors.blueGrey],
        'fairy': [Colors.pink, Colors.deepPurple],
      };
      return typeColors[type.toLowerCase()] ?? [Colors.grey, Colors.blueGrey];
    }

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.0),
          enableFeedback: true,
          onTap: () {
            // Navegación al detalle del Pokémon
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: types.map((type) => getTypeColors(type)).expand((colors) => colors).toList(),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formatPokemonNumber(number),
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Center(
                      child: CachedNetworkImage(
                        imageUrl: spriteUrl,
                        fit: BoxFit.contain,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) => const Icon(
                          Icons.broken_image,
                          size: 96,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          name.toString().toUpperCase(),
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),
                        ),
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 4,
                          children: types.map((type) => Chip(
                            label: Text(
                              type.toString().toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                            backgroundColor: getTypeColors(type.toString())[0],
                            padding: EdgeInsets.zero,
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          )).toList(),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
