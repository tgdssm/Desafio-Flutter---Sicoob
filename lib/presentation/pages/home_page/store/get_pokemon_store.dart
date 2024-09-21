import 'package:mobx/mobx.dart';
import 'package:pokedex/commons/states/states.dart';
import 'package:pokedex/core/domain/entities/poke_entity.dart';
import 'package:pokedex/core/domain/use_cases/get_pokemon_use_case/get_pokemon_use_case.dart';

class GetPokemonStore {
  final GetPokemonUseCase _useCase;

  Observable<BaseState> state = Observable(EmptyState());

  GetPokemonStore(this._useCase);

  Future<void> getPokemon() async {
    runInAction(() {
      state.value = const LoadingState();
    });

    final result = await _useCase();

    runInAction(() {
      if (result.isSuccess) {
        state.value = SuccessState<List<PokeEntity>>(result.successData);
      } else {
        state.value = ErrorState(result.errorData.message);
      }
    });
  }
}
