import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pokedex_flutter/graphql/queries/search_pokemon_by_number.dart';
import 'package:pokedex_flutter/widgets/pokemon_grid_item.dart';
import 'package:pokedex_flutter/widgets/popup_options/sorting_section.dart';
import '../graphql/queries/pokemon_list_query.dart';

class ListPokemon extends StatefulWidget {
  final Map<String, Set<String>> activeFilters;
  final SortOption currentSort;
  final String searchName;
  final int searchNumber;

  const ListPokemon({
    super.key,
    required this.activeFilters,
    required this.currentSort,
    required this.searchName,
    required this.searchNumber,
  });

  @override
  State<ListPokemon> createState() => _ListPokemonState();
}

class _ListPokemonState extends State<ListPokemon> {


  @override
  Widget build(BuildContext context) {
    final typesList = _getTypesList(widget.activeFilters['types']);

    return Query(
      options: widget.searchNumber == 0 ? QueryOptions(
          document: gql(queryPokemonList),
          fetchPolicy: FetchPolicy.cacheFirst,
          variables: {
            'types': _getTypesList(widget.activeFilters['types']),
            'generations': _getGenerationList(widget.activeFilters['generations']),
            'orderBy': widget.currentSort.field == SortField.id
                ? [{"id": widget.currentSort.order == SortOrder.asc ? "asc" : "desc"}]
                : [{"name": widget.currentSort.order == SortOrder.asc ? "asc" : "desc"}],
            'searchName': widget.searchName.isEmpty ? '%%' : '%${widget.searchName
                .toLowerCase()}%',
          }
      ) : QueryOptions(
          document: gql(searchPokemonByNumberQuery),
          fetchPolicy: FetchPolicy.cacheFirst,
          variables: {
            'number': widget.searchNumber
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

                return PokemonGridItem(pokemon: pokemon);
              },
              childCount: pokemons.length
          ),
        );
      },
    );
  }
}

List<String>? _getTypesList(Set<String>? types) {
  if (types == null || types.isEmpty) {
    return [
    'normal', 'fire', 'water', 'electric', 'grass', 'ice',
    'fighting', 'poison', 'ground', 'flying', 'psychic', 'bug',
    'rock', 'ghost', 'dragon', 'dark', 'steel', 'fairy'
  ];
  }
  return types.map((type) => type.toLowerCase()).toList();
}

List<int>? _getGenerationList(Set<String>? generations) {
  if (generations == null || generations.isEmpty){
    return [1, 2, 3, 4, 5, 6, 7, 8, 9];
  }
  return generations.map((generation) {
    final romanNumeral = generation.split(' ').last;
    switch (romanNumeral) {
      case 'I': return 1;
      case 'II': return 2;
      case 'III': return 3;
      case 'IV': return 4;
      case 'V': return 5;
      case 'VI': return 6;
      case 'VII': return 7;
      case 'VIII': return 8;
      case 'IX': return 9;
      default: return 1;
    }
  }).toList();
}