import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app/models/singletons/token_singleton.dart';
import 'package:quiz_app/utils/token_utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TokenHandler {
  bool _isTokenLoaded = false;

  @override
  void initState() {
    super.initState();
    retreiveOrGenerateToken().then((value) {
      if (value == null) {
        const AlertDialog(title: Text("Internet problem connection"));
      } else {
        generateTokenSingleton(value.token, DateTime.parse(value.timeStamp));
        setState(() {
          _isTokenLoaded = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 120),
              child: const Text(
                "Quiz Up",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 48,
                ),
              ),
            ),
            const Spacer(),
            Image.asset(
              'assets/images/quiz_illustration.png',
              height: 180,
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
                            _isTokenLoaded ? Colors.blue : Colors.grey),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40.0),
                                    side:
                                        const BorderSide(color: Colors.blue)))),
                    onPressed: () =>
                        _isTokenLoaded ? context.push('/category') : null,
                    child: Text("Start".toUpperCase(),
                        style: const TextStyle(fontSize: 24))))
          ]),
    ));
  }
}
