import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../graphql/queries/pokemon_list_query.dart';

class ListPokemon extends StatelessWidget {
  final Map<String, Set<String>> activeFilters;

  const ListPokemon({super.key, required this.activeFilters});

  String _formatPokemonNumber(int number) {
    return '#${number.toString().padLeft(3, '0')}';
  }

  List<Color> _getTypeColors(String type) {
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

  @override
  Widget build(BuildContext context) {
    final typesList = _getTypesList(activeFilters['types']);

    return Query(
      options: QueryOptions(
        document: gql(queryPokemonList),
        fetchPolicy: FetchPolicy.cacheFirst,
        variables: {
          'types': _getTypesList(activeFilters['types']),
        }
      ),
      builder: (result, {fetchMore, refetch}) {
        if (result.isLoading) {
          return const SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator())
          );
        }

        if (result.hasException) {
          return SliverToBoxAdapter(
            child: Center(child: Text('Error: ${result.exception.toString()}')),
          );
        }

        final List pokemons = result.data!['pokemon_v2_pokemon'];

        if (pokemons.isEmpty) {
          return const SliverToBoxAdapter(
            child: Center(child: Text('No Pokémon found')),
          );
        }

        return SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 5.0
          ),
          delegate: SliverChildBuilderDelegate(
                  (context, index) {
                final pokemon = pokemons[index];
                final number = pokemon['id'];
                final name = pokemon['name'];
                final types = (pokemon['pokemon_v2_pokemontypes'] as List)
                    .map((type) => type['pokemon_v2_type']['name'])
                    .toList();
                final spriteUrl = pokemon['pokemon_v2_pokemonsprites'][0]['sprites'];

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
                            colors: types.map((type) => _getTypeColors(type)).expand((colors) => colors).toList(),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _formatPokemonNumber(number),
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
                                        backgroundColor: _getTypeColors(type.toString())[0],
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
              },
              childCount: pokemons.length
          ),
        );
      },
    );
  }
}

List<String>? _getTypesList(Set<String>? types) {
  if (types == null || types.isEmpty) return [
    'normal', 'fire', 'water', 'electric', 'grass', 'ice',
    'fighting', 'poison', 'ground', 'flying', 'psychic', 'bug',
    'rock', 'ghost', 'dragon', 'dark', 'steel', 'fairy'
  ];
  return types.map((type) => type.toLowerCase()).toList();
}