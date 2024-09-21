import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';
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

import '../../../core/data/data_mock.dart';
import '../../run_test_widget.dart';

class GetPokemonStoreMock extends Mock implements GetPokemonStore {}

void main() {
  late GetPokemonStore storeMock;
  late PokeEntity entity;
  late List<PokeEntity> listEntity;
  final getIt = GetIt.instance;

  setUp(() {
    storeMock = GetPokemonStoreMock();
    getIt.registerSingleton<GetPokemonStore>(storeMock);

    entity = PokeModel.fromMap(pokeDataMock);
    listEntity = [entity, entity, entity];

    // Corrige o mock para o método getPokemon retornar Future<void>
    when(() => storeMock.getPokemon()).thenAnswer((_) async => Future.value());
  });

  tearDown(() {
    getIt.reset();
  });

  group('[PRESENTATION] - HomePage', () {
    testWidgets(
      'LoadingState',
          (tester) async {
        when(() => storeMock.state).thenReturn(mobx.Observable(LoadingState()));

        await tester.pumpWidget(
          runPageTest(
            const HomePage(
              key: Key('HomePage'),
            ),
          ),
        );

        await tester.pump();

        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.byType(LoadingHomeComponent), findsOneWidget);
      },
    );

    testWidgets(
      'ErrorState',
          (tester) async {
        when(() => storeMock.state).thenReturn(mobx.Observable(ErrorState('Error')));

        await tester.pumpWidget(
          runPageTest(
            const HomePage(
              key: Key('HomePage'),
            ),
          ),
        );

        await tester.pump();

        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.byType(ErrorHomeComponent), findsOneWidget);
      },
    );

    testWidgets(
      'EmptyState',
          (tester) async {
        when(() => storeMock.state).thenReturn(mobx.Observable(EmptyState()));

        await tester.pumpWidget(
          runPageTest(
            const HomePage(
              key: Key('HomePage'),
            ),
          ),
        );

        await tester.pump();

        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.byType(LoadingHomeComponent), findsOneWidget);
      },
    );

    testWidgets(
      'SuccessState',
          (tester) async {
        when(() => storeMock.state).thenReturn(mobx.Observable(SuccessState<List<PokeEntity>>(listEntity)));

        await mockNetworkImagesFor(() async {
          await tester.pumpWidget(
            runPageTest(
              const HomePage(
                key: Key('HomePage'),
              ),
            ),
          );

          await tester.pump();

          expect(find.byType(Scaffold), findsOneWidget);
          expect(find.byType(PokedexInputField), findsOneWidget);
          expect(find.byType(PokedexFilterButton), findsOneWidget);
          expect(find.byType(LoadingHomeComponent), findsNothing);
          expect(find.byType(ErrorHomeComponent), findsNothing);
          expect(find.byType(PokedexCardComponent), findsNWidgets(3));
        });
      },
    );
  });
}
