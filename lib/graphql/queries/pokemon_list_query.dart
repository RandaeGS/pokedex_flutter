const String queryPokemonList = """
query listPokemons(\$types: [String!], \$generations: [Int!]) {
pokemon_v2_pokemon(
  limit: 80,
  where: {
    _and: [
      {
        pokemon_v2_pokemontypes: {
          pokemon_v2_type: {
            name: {
              _in: \$types
            }
          }
        }
      },
      {
        pokemon_v2_pokemonspecy: {
          generation_id: {
            _in: \$generations
          }
        }
      }
    ]
  }) {
  id
  name
  pokemon_v2_pokemontypes {
    pokemon_v2_type {
      name
    }
  }
  pokemon_v2_pokemonsprites {
    sprites(path: "other.official-artwork.front_default")
  }
  pokemon_v2_pokemonspecy {
    generation_id
  }
}
}""";