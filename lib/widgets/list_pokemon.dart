import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../graphql/queries/pokemon_list_query.dart';

class ListPokemon extends StatelessWidget {
  const ListPokemon({super.key});

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
                .join(", ");


                return Card(
                  elevation: 5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(name)
                    ],
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
