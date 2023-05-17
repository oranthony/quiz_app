import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/providers.dart';
import 'package:quiz_app/utils/app_colors.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class EndgameScreen extends StatefulWidget {
  //const GameScreen({super.key});
  const EndgameScreen({Key? key}) : super(key: key);

  @override
  State<EndgameScreen> createState() => _EndgameScreenState();
}

class _EndgameScreenState extends State<EndgameScreen> {
  late GameSessionProvider _gameSessionProvider;

  var _animationHeight = 0.0;
  final _delayBeforeAnimation = const Duration(microseconds: 800);

  final _backgroundColor = AppColors.falseColor;

  final _colors = [
    AppColors.trueColor,
    //Color.fromARGB(255, 87, 200, 30),
  ];

  static const _durations = [
    1800,
    //100,
  ];

  static const _heightPercentages = [
    0.0,
    //0.18,
  ];

  int _getAmountOfQuestions() {
    if (_gameSessionProvider.getQuestions.results != null) {
      return _gameSessionProvider.getQuestions.results!.isEmpty
          ? 0
          : _gameSessionProvider.getQuestions.results!.length;
    } else {
      return 0;
    }
  }

  @override
  void initState() {
    _gameSessionProvider =
        Provider.of<GameSessionProvider>(context, listen: false);

    Future.delayed(_delayBeforeAnimation, () {
      setState(() {
        _animationHeight = _computeWinRatio();
      });
    });
    super.initState();
  }

  double _computeWinRatio() {
    double screenHeight = MediaQuery.of(context).size.height;
    if (_gameSessionProvider.score == 0) {
      return 0.0;
    }
    if (_gameSessionProvider.getQuestions.results != null &&
        _gameSessionProvider.getQuestions.results!.isNotEmpty) {
      double scoreRatio = _gameSessionProvider.score /
          _gameSessionProvider.getQuestions.results!.length;
      return screenHeight * scoreRatio;
    }
    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.falseColor,
        body: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: <Widget>[
              AnimatedSize(
                curve: Curves.easeOut,
                duration: const Duration(milliseconds: 800),
                child: SizedBox(
                  height: _animationHeight,
                  width: double.infinity,
                  child: WaveWidget(
                    config: CustomConfig(
                      colors: _colors,
                      durations: _durations,
                      heightPercentages: _heightPercentages,
                    ),
                    backgroundColor: _backgroundColor,
                    size: const Size(double.infinity, double.infinity),
                    waveAmplitude: 2,
                  ),
                ),
              ),
              Column(
                children: [
                  Container(
                    height: 60,
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 260),
                    child: Center(
                        child: Text(
                      "${_gameSessionProvider.score} / ${_getAmountOfQuestions()}",
                      style: const TextStyle(fontSize: 60, color: Colors.white),
                    )),
                  ),
                  const Spacer(),
                  Container(
                    margin: const EdgeInsets.only(bottom: 70),
                    child: TextButton(
                        style: ButtonStyle(
                            padding: MaterialStateProperty.all<EdgeInsets>(
                                const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 15,
                            )),
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.blue),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40.0),
                                    side:
                                        const BorderSide(color: Colors.blue)))),
                        onPressed: () => context.go('/category'),
                        child: Text("Play again".toUpperCase(),
                            style: const TextStyle(fontSize: 22))),
                  ),
                ],
              ),
            ]));
  }
}
