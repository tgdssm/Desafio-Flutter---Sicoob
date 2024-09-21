import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart' as mocktail;
import 'package:mobx/mobx.dart' as mobx;
import 'package:pokedex/commons/pokedex_ui/widgets/pokedex_filter_button.dart';
import 'package:pokedex/commons/pokedex_ui/widgets/pokedex_input_field.dart';
import 'package:pokedex/commons/states/states.dart';
import 'package:pokedex/core/data/models/poke_model/poke_model.dart';
import 'package:pokedex/core/domain/entities/poke_entity.dart';
import 'package:pokedex/presentation/pages/home_page/components/error_home_component.dart';
import 'package:pokedex/presentation/pages/home_page/components/loading_home_component.dart';
import 'package:pokedex/presentation/pages/home_page/components/pokedex_card_component.dart';
import 'package:pokedex/presentation/pages/home_page/home_page.dart';
import 'package:pokedex/presentation/pages/home_page/store/get_pokemon_store.dart';

import '../../../test/presentation/run_test_widget.dart';
import '../../data_mock.dart';

class GetPokemonStoreMock extends mocktail.Mock implements GetPokemonStore {}

void main() {
  late GetPokemonStore storeMock;
  late List<PokeEntity> entities;
  final getIt = GetIt.instance;

  setUp(() {
    storeMock = GetPokemonStoreMock();
    getIt.registerSingleton<GetPokemonStore>(storeMock);

    entities = dataIntegrationListMocks
        .map<PokeEntity>((map) => PokeModel.fromMap(map))
        .toList();
  });

  tearDown(() {
    getIt.reset();
  });

  testWidgets(
    '[PRESENTATION] HomePage - Success Scenario',
        (tester) async {
      mocktail.when(() => storeMock.getPokemon()).thenAnswer((_) async => Future.value());

      mocktail.when(() => storeMock.state).thenReturn(mobx.Observable(SuccessState<List<PokeEntity>>(entities)));

      await tester.pumpWidget(
        runPageTest(
          const HomePage(key: Key('HomePage')),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(PokedexCardComponent), findsWidgets);
      expect(find.byType(PokedexInputField), findsOneWidget);
      expect(find.byType(PokedexFilterButton), findsOneWidget);
      expect(find.byType(LoadingHomeComponent), findsNothing);
      expect(find.byType(ErrorHomeComponent), findsNothing);
    },
  );
}
