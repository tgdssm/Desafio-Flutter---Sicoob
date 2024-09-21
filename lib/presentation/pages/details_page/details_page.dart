import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:pokedex/commons/pokedex_ui/enums/pokedex_icons_enum.dart';
import 'package:pokedex/commons/pokedex_ui/enums/pokedex_types_enum.dart';
import 'package:pokedex/commons/pokedex_ui/extensions/color_extensions.dart';
import 'package:pokedex/commons/pokedex_ui/helpers/select_pokedex_type_by_string.dart';
import 'package:pokedex/commons/pokedex_ui/palettes/colors.dart';
import 'package:pokedex/commons/pokedex_ui/widgets/pokedex_icon.dart';
import 'package:pokedex/core/domain/entities/poke_entity.dart';
import 'package:pokedex/presentation/pages/details_page/components/header_title_component.dart';
import 'package:pokedex/presentation/pages/details_page/components/pokemon_images_component.dart';
import '../../../commons/pokedex_ui/stores/validator_store.dart';
import 'components/card_body_component.dart';

class DetailsPageParams {
  final List<PokeEntity> pokes;
  final int index;

  DetailsPageParams({required this.pokes, required this.index});
}

class DetailsPage extends StatefulWidget {
  final DetailsPageParams params;

  const DetailsPage({Key? key, required this.params}) : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late PokeEntity pokeSelected;
  late PokedexTypesEnum type;
  late Color currentColor;

  late ValidatorStore<int> _jumpPokemonStore;

  @override
  void initState() {
    super.initState();
    _updatePokemon(widget.params.index);
    _jumpPokemonStore = ValidatorStore<int>(widget.params.index);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Observer(
      builder: (_) {
        final indexPage = _jumpPokemonStore.value.value;

        return Scaffold(
          backgroundColor: currentColor,
          body: Stack(
            children: [
              CardBodyComponent(
                color: currentColor,
                pokemon: pokeSelected,
              ),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.only(right: size.height * 0.02),
                  child: PokedexIcon(
                    color: currentColor.light(0.06),
                    icon: PokedexIconsEnum.pokeball,
                    size: size.height * 0.25,
                  ),
                ),
              ),
              PokemonImagesComponent(
                pokemon: pokeSelected,
                next: indexPage + 1 >= widget.params.pokes.length
                    ? null
                    : () {
                  _jumpToNextPokemon(indexPage + 1);
                },
                back: indexPage > 0
                    ? () {
                  _jumpToNextPokemon(indexPage - 1);
                }
                    : null,
              ),
              HeaderTitleComponent(
                name: pokeSelected.name,
              ),
            ],
          ),
        );
      },
    );
  }

  void _updatePokemon(int index) {
    pokeSelected = widget.params.pokes[index];
    type = selectPokedexTypeByString(pokeSelected.types[0]);
    currentColor = AppColors.getColorForType(type);
  }

  void _jumpToNextPokemon(int index) {
    runInAction(() {
      _updatePokemon(index);
      _jumpPokemonStore.updateValue(index);
    });
  }

}
