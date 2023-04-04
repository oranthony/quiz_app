import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app/src/view/screens/before_quiz_screen.dart';
import 'package:quiz_app/src/view/screens/category_screen.dart';
import 'package:quiz_app/src/view/screens/game_screen.dart';
import 'package:quiz_app/src/view/screens/home_screen.dart';
import 'package:quiz_app/src/view/screens/test.dart';
import 'package:quiz_app/utils/ripple.dart';

void main() {
  runApp(const MainApp());
}

// GoRouter configuration
final _router = GoRouter(
  routes: [
    GoRoute(
        path: '/',
        //builder: (context, state) => const HomeScreen(),
        builder: (context, state) => /*const*/ GameScreen(),
        routes: <RouteBase>[
          GoRoute(
            path: 'category',
            builder: (BuildContext context, GoRouterState state) {
              return const CategoryScreen();
            },
          ),
        ]),
  ],
);

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.lightBlue[800],

        // Define the default font family.
        fontFamily: 'Roboto',

        // Define the default `TextTheme`. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          titleLarge: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          bodyMedium: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
      ),
      /*home: const Scaffold(
        body: Center(
          child: HomePage(),
        ),
      ),*/
    );
  }
}
