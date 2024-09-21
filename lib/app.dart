import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pokedex/commons/config/routes.dart';
import 'package:pokedex/commons/config/strings.dart';
import 'package:pokedex/commons/pokedex_ui/widgets/pokedex_scroll_configuration.dart';
import 'package:pokedex/presentation/pages/details_page/details_page.dart';
import 'package:pokedex/presentation/pages/home_page/home_page.dart';


class AppStart extends StatelessWidget {
  const AppStart({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: AppRoutes.root,
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: AppRoutes.details,
          builder: (context, state) => DetailsPage(params: state.extra as DetailsPageParams),
        ),
      ],
    );

    return MaterialApp.router(
      title: AppString.title,
      theme: ThemeData(
        //fontFamily: 'Poppins',
      ),
      builder: (context, child) => SafeArea(
        child: PokedexScrollConfiguration(
          child: child!,
        ),
      ),
      routerConfig: router,
    );
  }
}

