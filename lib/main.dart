import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/models/api_token.dart';
import 'package:quiz_app/models/singletons/token_singleton.dart';
import 'package:quiz_app/providers.dart';
import 'package:quiz_app/services/api_service.dart';
import 'package:quiz_app/src/view/screens/before_quiz_screen.dart';
import 'package:quiz_app/src/view/screens/category_screen.dart';
import 'package:quiz_app/src/view/screens/endgame_screen.dart';
import 'package:quiz_app/src/view/screens/game_screen.dart';
import 'package:quiz_app/src/view/screens/home_screen.dart';
import 'package:quiz_app/src/view/widgets/ripple.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => GameSessionProvider()),
    ],
    child: const MainApp(),
  ));
}

// GoRouter configuration
final _router = GoRouter(
  routes: [
    GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
        routes: <RouteBase>[
          GoRoute(
            path: 'category',
            builder: (BuildContext context, GoRouterState state) {
              return const CategoryScreen();
            },
          ),
          GoRoute(
            path: 'before_quiz',
            builder: (BuildContext context, GoRouterState state) {
              return const BeforeQuizScreen();
            },
          ),
          GoRoute(
            path: 'game_screen',
            builder: (BuildContext context, GoRouterState state) {
              return const GameScreen();
            },
          ),
          GoRoute(
              path: 'endGame',
              builder: (BuildContext context, GoRouterState state) {
                return const EndgameScreen();
              })
        ]),
  ],
);

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: _router,
        theme: ThemeData(
          //brightness: Brightness.light,
          primaryColor: Colors.lightBlue[800],
          //trueColor: Color(0xFF69CE39),

          // Define the default font family.
          fontFamily: 'Roboto',

          // Define the default `TextTheme`. Use this to specify the default
          // text styling for headlines, titles, bodies of text, and more.
          textTheme: const TextTheme(
            displayLarge:
                TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            titleLarge: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
            bodyMedium: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
          ),
        ),
      ),
    );
  }
}
