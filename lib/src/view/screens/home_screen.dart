import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  //double screenWidth = 600;
  //double screenHeight = 400;

  @override
  Widget build(BuildContext context) {
    //screenWidth = MediaQuery.of(context).size.width;
    //screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        body: Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 120),
              child: const Text(
                "Quiz Game",
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
            Container(
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
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.blue),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40.0),
                                    side:
                                        const BorderSide(color: Colors.blue)))),
                    onPressed: () => context.push('/category'),
                    child: Text("Start".toUpperCase(),
                        style: const TextStyle(fontSize: 24))))
          ]),
    ));
  }
}
