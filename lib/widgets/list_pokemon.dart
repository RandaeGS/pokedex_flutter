import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../graphql/queries/pokemon_list_query.dart';

class ListPokemon extends StatelessWidget {
  const ListPokemon({super.key});

  String _formatPokemonNumber(int number) {
    return '#${number.toString().padLeft(3, '0')}';
  }

  Color _getTypeColor(String type) {
    final typeColors = {
      'fire': Colors.red,
      'water': Colors.blue,
      'grass': Colors.green,
      'electric': Colors.yellow,
    };
    return typeColors[type.toLowerCase()] ?? Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: gql(queryPokemonList),
        fetchPolicy: FetchPolicy.cacheFirst,
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

                return Card(
                  elevation: 4,
                  child: InkWell(
                    onTap: () {
                      // Navegación al detalle del Pokémon
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _formatPokemonNumber(number),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: Center(
                              child: Image.network(
                                'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$number.png',
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.broken_image, size: 96);
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            name.toString().toUpperCase(),
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Wrap(
                            spacing: 4,
                            children: types.map((type) => Chip(
                              label: Text(
                                type.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                              backgroundColor: _getTypeColor(type.toString()),
                              padding: EdgeInsets.zero,
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            )).toList(),
                          ),
                        ],
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
