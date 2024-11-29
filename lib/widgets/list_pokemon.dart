import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pokedex_flutter/graphql/queries/pokemon_list_by_types.dart';
import 'package:pokedex_flutter/graphql/queries/search_pokemon_by_number.dart';
import 'package:pokedex_flutter/widgets/pokemon_grid_item.dart';
import 'package:pokedex_flutter/widgets/popup_options/sorting_section.dart';
import '../graphql/queries/pokemon_list_query.dart';

class ListPokemon extends StatefulWidget {
  final Map<String, Set<String>> activeFilters;
  final SortOption currentSort;
  final String searchName;
  final int searchNumber;
  final bool updateFilter;

  const ListPokemon({
    super.key,
    required this.activeFilters,
    required this.currentSort,
    required this.searchName,
    required this.searchNumber,
    required this.updateFilter
  });

  @override
  State<ListPokemon> createState() => _ListPokemonState();
}

class _ListPokemonState extends State<ListPokemon> {
  static const _pageSize = 20;
  final PagingController<int, dynamic> _pagingController = PagingController(firstPageKey: 0);

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  @override
  void didUpdateWidget(covariant ListPokemon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.updateFilter ||
        oldWidget.currentSort != widget.currentSort ||
        oldWidget.searchName != widget.searchName ||
        oldWidget.searchNumber != widget.searchNumber) {
      _pagingController.refresh();
    }
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final client = GraphQLProvider.of(context).value;
      final options = widget.searchNumber == 0
          ? (widget.currentSort.field == SortField.type
          ? QueryOptions(
          document: gql(pokemonListByType),
          fetchPolicy: FetchPolicy.cacheFirst,
          variables: {
            'offset': pageKey * _pageSize,
            'limit': _pageSize,
            'name': widget.currentSort.order == SortOrder.asc ? "asc" : "desc",
            'types': _getTypesList(widget.activeFilters['types']),
            'generations': _getGenerationList(widget.activeFilters['generations']),
            'searchName': widget.searchName.isEmpty ? '%%' : '%${widget.searchName.toLowerCase()}%',
          }
      )
          : QueryOptions(
          document: gql(queryPokemonList),
          fetchPolicy: FetchPolicy.cacheFirst,
          variables: {
            'offset': pageKey * _pageSize,
            'limit': _pageSize,
            'types': _getTypesList(widget.activeFilters['types']),
            'generations': _getGenerationList(widget.activeFilters['generations']),
            'orderBy': widget.currentSort.field == SortField.id
                ? [{"id": widget.currentSort.order == SortOrder.asc ? "asc" : "desc"}]
                : [{"name": widget.currentSort.order == SortOrder.asc ? "asc" : "desc"}],
            'searchName': widget.searchName.isEmpty ? '%%' : '%${widget.searchName.toLowerCase()}%',
          }
      )
      )
          : QueryOptions(
          document: gql(searchPokemonByNumberQuery),
          fetchPolicy: FetchPolicy.cacheFirst,
          variables: {
            'number': widget.searchNumber
          }
      );

      final result = await client.query(options);
      final List pokemons = widget.currentSort.field == SortField.type
          ? result.data!['pokemon_v2_pokemontype']
          .map((type) => type['pokemon_v2_pokemon'])
          .toList()
          : result.data!['pokemon_v2_pokemon'];

      final isLastPage = pokemons.length < _pageSize;

      if (isLastPage) {
        _pagingController.appendLastPage(pokemons);
      } else {
        _pagingController.appendPage(pokemons, pageKey + 1);
      }

    } catch (error) {
      _pagingController.error = error;
    }
  }
  @override
  Widget build(BuildContext context) {

    return PagedSliverGrid<int, dynamic>(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
        childAspectRatio: 0.85
      ),
      builderDelegate: PagedChildBuilderDelegate(
        itemBuilder: (context, item, index) {

          return PokemonGridItem(pokemon: item);
        },
        firstPageProgressIndicatorBuilder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
        noItemsFoundIndicatorBuilder: (context) => const Center(
          child: Text('No Pokemon Found'),
        ),
      ),
      pagingController: _pagingController,
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