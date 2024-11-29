import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pokedex_flutter/graphql/queries/get_abilities.dart';

class AbilityAutocomplete extends StatefulWidget {
  final Function(String) onAbilitySelected;

  const AbilityAutocomplete({
    super.key,
    required this.onAbilitySelected,
  });

  @override
  State<AbilityAutocomplete> createState() => _AbilityAutocompleteState();
}

class _AbilityAutocompleteState extends State<AbilityAutocomplete> {
  String searchText = '';

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: gql(getAbilities),
        variables: {
          'searchText': '%${searchText.toLowerCase()}%',
        },
      ),
      builder: (QueryResult result, {fetchMore, refetch}) {
        if (result.hasException) {
          return Text('Error: ${result.exception.toString()}');
        }

        final List<String> abilities = result.data?['pokemon_v2_ability']
            ?.map<String>((ability) => ability['name'] as String)
            .toList() ?? [];

        return Autocomplete<String>(
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text == '') {
              return const Iterable<String>.empty();
            }
            setState(() {
              searchText = textEditingValue.text;
            });
            return abilities.where((ability) {
              return ability.toLowerCase()
                  .contains(textEditingValue.text.toLowerCase());
            });
          },
          onSelected: widget.onAbilitySelected,
          fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
            return TextField(
              controller: textEditingController,
              focusNode: focusNode,
              decoration: InputDecoration(
                labelText: 'Search by ability',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                suffixIcon: result.isLoading
                    ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2)
                )
                    : const Icon(Icons.search),
              ),
            );
          },
          optionsViewBuilder: (context, onSelected, options) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 4,
                child: Container(
                  width: 300,
                  constraints: const BoxConstraints(maxHeight: 200),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      final ability = options.elementAt(index);
                      return ListTile(
                        title: Text(ability),
                        onTap: () => onSelected(ability),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}