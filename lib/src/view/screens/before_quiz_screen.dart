import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/models/question.dart';
import 'package:quiz_app/providers.dart';
import 'package:http/http.dart' as http;

class BeforeQuizScreen extends StatefulWidget {
  const BeforeQuizScreen({super.key});

  @override
  State<BeforeQuizScreen> createState() => _BeforeQuizScreenState();
}

class _BeforeQuizScreenState extends State<BeforeQuizScreen> {
  late GameSessionProvider _gameSessionProvider;

  @override
  void initState() {
    // Making sure the build function has been called before updating state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // reset score and step in case of multiple games in a row
      _gameSessionProvider.score = 0;
      _gameSessionProvider.step = 0;
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _gameSessionProvider =
        Provider.of<GameSessionProvider>(context, listen: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
          _buildAppBarr(context),
          Container(
            padding: const EdgeInsets.only(top: 40, left: 40, right: 40),
            child: const Text(
                "This quiz only has questions that can be answered with true or false.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16)),
          ),
          const Spacer(),
          SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              child: Lottie.asset('assets/animations/select-animation.json')),
          Container(
            padding: const EdgeInsets.only(top: 25),
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(top: 0),
                  child: const Text("Swipe Up for true",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20)),
                ),
                Container(
                    padding: const EdgeInsets.only(top: 15),
                    child: const Text("Swipe Down for false",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20))),
              ],
            ),
          ),
          const Spacer(),
          AnimatedContainer(
              duration: const Duration(milliseconds: 350),
              margin: const EdgeInsets.only(bottom: 50),
              child: TextButton(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 15,
                      )),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          _gameSessionProvider.isLoaded
                              ? Colors.blue
                              : Colors.grey),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0),
                      ))),
                  onPressed: () => _gameSessionProvider.isLoaded
                      ? context.push('/game_screen')
                      : null,
                  child: Text("Start".toUpperCase(),
                      style: const TextStyle(fontSize: 24))))
        ]));
  }

  Container _buildAppBarr(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 80),
        child: SizedBox(
            width: double.infinity,
            height: 60,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                const Center(
                  child: Text(
                    "How it works",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 32,
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, size: 32),
                      onPressed: () {
                        context.pop();
                      },
                    ),
                  ),
                ),
              ],
            )));
  }
}
