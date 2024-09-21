import 'package:get_it/get_it.dart';
import 'package:pokedex/core/data/datasources/pokedex_datasource/pokedex_datasource.dart';
import 'package:pokedex/core/data/repositories/pokedex_repository/pokedex_repository_impl.dart';
import 'package:pokedex/core/domain/repositories/pokedex_repository/pokedex_repository.dart';
import 'package:pokedex/core/domain/use_cases/get_pokemon_use_case/get_pokemon_use_case.dart';
import 'package:pokedex/core/domain/use_cases/get_pokemon_use_case/get_pokemon_use_case_impl.dart';
import 'package:dio/dio.dart';
import 'package:pokedex/commons/http_client/dio_http_client_impl.dart';
import 'package:pokedex/commons/http_client/http_client.dart';
import 'package:pokedex/presentation/pages/home_page/store/get_pokemon_store.dart';
import 'core/data/datasources/pokedex_datasource/pokedex_datasource_impl.dart';

final getIt = GetIt.instance;
void setupDependencies() {
  getIt.registerSingleton<Dio>(Dio());
  getIt.registerFactory<HttpAppClient>(() => DioHttpClient(getIt()));
  getIt.registerFactory<PokedexDataSource>(() => PokedexDataSourceImpl(getIt()));
  getIt.registerFactory<PokedexRepository>(() => PokedexRepositoryImpl(getIt()));
  getIt.registerFactory<GetPokemonUseCase>(() => GetPokemonUseCaseImpl(getIt()));
  getIt.registerFactory<GetPokemonStore>(() => GetPokemonStore(getIt()));
}