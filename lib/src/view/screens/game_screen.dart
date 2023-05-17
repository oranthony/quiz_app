import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app/models/question.dart';
import 'package:quiz_app/providers.dart';
import 'package:quiz_app/utils/app_colors.dart';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'package:html_unescape/html_unescape.dart';
import 'package:provider/provider.dart';

import 'package:quiz_app/src/view/widgets/ripple.dart';

class GameScreen extends StatefulWidget {
  //const GameScreen({super.key});
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  // Used to keep track of the BlinkAnimation Widget -> the animation is
  // triggered from GameScreen class (allows to access its state from this class)
  final rippleKey = GlobalKey<BlinkAnimationState>();
  // Used for unescaping HTML-encoded strings because of API encoding
  var unescape = HtmlUnescape();

  late GameSessionProvider _gameSessionProvider;

  // delay between 2 questions
  final _delaybetweenQuestion = const Duration(milliseconds: 130);
  // fade animation delay
  final _questionFadeAnimationDelay = const Duration(milliseconds: 180);

  late int _amountOfQuestion;
  // Amount of good answers, stored within the the widget state for the duration
  // of the game and pushed to the provider when the game is finished
  int _score = 0;
  // Use to manage the fade animation of the questions
  bool _visible = true;

  @override
  void initState() {
    super.initState();
    _gameSessionProvider =
        Provider.of<GameSessionProvider>(context, listen: false);

    if (_gameSessionProvider.questions.responseCode == 1 ||
        _gameSessionProvider.questions.responseCode == 4) {
      print("no questions");
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showMyDialog();
      });
    }

    if (_gameSessionProvider.questions.results != null) {
      _amountOfQuestion = _gameSessionProvider.questions.results!.length;
    }
  }

  String _getQuestion() {
    if (_gameSessionProvider.questions.results != null) {
      return _gameSessionProvider.questions.results!.isNotEmpty
          ? unescape.convert(_gameSessionProvider
              .questions.results![_gameSessionProvider.step].question!)
          : "";
    } else {
      return "";
    }
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('API Problem'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text("We don't have anymore questions for this category."),
                Text('Please go back and choose another category.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Go back'),
              onPressed: () {
                // Dissmiss modal
                Navigator.of(context).pop();
                // Go back to category screen to pick up another category
                context.go('/category');
              },
            ),
          ],
        );
      },
    );
  }

  void _finishGame() {
    _gameSessionProvider.score = _score;
    context.push('/endGame');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Container(
          height: 100,
          width: double.infinity,
          color: AppColors.trueColor,
        ),
        Expanded(
            child: AnimatedOpacity(
                opacity: _visible ? 1.0 : 0.0,
                duration: _questionFadeAnimationDelay,
                child: _buildGestureDetectorWidget(
                    _buildTextQuestionWidget(_getQuestion())))),
        Container(
          height: 100,
          width: double.infinity,
          color: AppColors.falseColor,
        ),
      ],
    ));
  }

  /// Builds the GestureDetector Widget that detects when the user swipe Up or
  /// Down and display the question in the midle.
  ///
  /// [child] is the question displayed inside the gesture detector. It accepts
  /// every type of content like picture or video, but currently it only
  /// displays text question
  GestureDetector _buildGestureDetectorWidget(Widget child) {
    return (GestureDetector(
        // Using the DragEndDetails allows us to only fire once per swipe.
        onVerticalDragEnd: (dragEndDetails) {
          if (dragEndDetails.primaryVelocity! < 0) {
            // Swipped Up
            if (_gameSessionProvider.questions
                    .results![_gameSessionProvider.step].correctAnswer ==
                "True") {
              // Good answer
              rippleKey.currentState?.isWrong = false;
              _score++;
            } else {
              // Wrong answer
              rippleKey.currentState?.isWrong = true;
            }
            // Start animation
            rippleKey.currentState?.startAnimation();
            setState(() {
              _visible = !_visible;
            });

            Future.delayed(_delaybetweenQuestion, () {
              // <-- delay to wait the end of animation
              setState(() {
                if (_gameSessionProvider.step == _amountOfQuestion - 1) {
                  // Game is over
                  _finishGame();
                } else {
                  // Go nto next question
                  _gameSessionProvider.incrementStep();
                  _visible = !_visible;
                }
              });
            });
          } else if (dragEndDetails.primaryVelocity! > 0) {
            // Swipped Down
            if (_gameSessionProvider.questions
                    .results![_gameSessionProvider.step].correctAnswer ==
                "True") {
              // Wrong answer
              rippleKey.currentState?.isWrong = true;
            } else {
              // Good answer
              rippleKey.currentState?.isWrong = false;
              _score++;
            }
            // Start animation
            rippleKey.currentState?.startAnimation();
            setState(() {
              _visible = !_visible;
            });
            Future.delayed(_delaybetweenQuestion, () {
              // <-- delay to wait the end of animation
              setState(() {
                if (_gameSessionProvider.step == _amountOfQuestion - 1) {
                  // Game is over
                  _finishGame();
                } else {
                  // Go to next question
                  _gameSessionProvider.incrementStep();
                  _visible = !_visible;
                }
              });
            });
          }
        },
        child: child));
  }

  // Used to build the Text widget to display the question whent the question is
  // in the form of a String
  Container _buildTextQuestionWidget(String question) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: BlinkAnimation(
          key: rippleKey,
          child: Container(
              margin: const EdgeInsets.only(left: 70, right: 70),
              child: Text(
                //_getQuestion(),
                question,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20),
              ))),
    );
  }
}
