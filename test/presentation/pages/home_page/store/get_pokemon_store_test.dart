import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as mocktail;
import 'package:mobx/mobx.dart' as mobx;
import 'package:pokedex/commons/errors/base_error.dart';
import 'package:pokedex/commons/result_wrapper/result_wrapper.dart';
import 'package:pokedex/commons/states/states.dart';
import 'package:pokedex/core/domain/use_cases/get_pokemon_use_case/get_pokemon_use_case.dart';
import 'package:pokedex/presentation/pages/home_page/store/get_pokemon_store.dart';

class GetPokemonUseCaseMock extends mocktail.Mock implements GetPokemonUseCase {}

void main() {
  late GetPokemonUseCase useCase;
  late GetPokemonStore store;

  setUp(() {
    useCase = GetPokemonUseCaseMock();
    store = GetPokemonStore(useCase);
  });

  test('[MOBX] GetPokemonStore - Success', () async {
    mocktail.when(() => useCase()).thenAnswer((_) async => ResultSuccess([]));

    final future = mobx.when(
          (reaction) => store.state.value is SuccessState,
          () {},
      timeout: 1000,
    );

    store.getPokemon();

    await future;

    expect(store.state.value, isA<SuccessState>());
  });

  test('[MOBX] GetPokemonStore - Error', () async {
    mocktail.when(() => useCase()).thenAnswer((_) async => ResultError(BaseError('Error fetching data')));

    final future = mobx.when(
          (reaction) => store.state.value is ErrorState,
          () {},
      timeout: 1000,
    );

    store.getPokemon();

    await future;

    expect(store.state.value, isA<ErrorState>());
  });
}
