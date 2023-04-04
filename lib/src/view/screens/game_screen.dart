import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:developer' as developer;

import 'package:quiz_app/utils/ripple.dart';

class GameScreen extends StatelessWidget {
  /*const*/ GameScreen({super.key});

  final rippleKey = GlobalKey<BlinkAnimationState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Container(
          height: 100,
          width: double.infinity,
          color: Color(0xFF69CE39),
        ),
        Expanded(
            child: GestureDetector(
                // Using the DragEndDetails allows us to only fire once per swipe.
                onVerticalDragEnd: (dragEndDetails) {
                  if (dragEndDetails.primaryVelocity! < 0) {
                    // Page forwards
                    print('up');
                    developer.log('up', name: 'my.app.category');
                    rippleKey.currentState?.isWrong = false;
                    rippleKey.currentState?.startAnimation();
                  } else if (dragEndDetails.primaryVelocity! > 0) {
                    // Page backwards
                    print('down');
                    developer.log('down', name: 'my.app.category');
                    rippleKey.currentState?.isWrong = true;
                    rippleKey.currentState?.startAnimation();
                  }
                },
                child: Container(
                  width: double.infinity,
                  color: Colors.white,
                  //child: Center(child: Text("Is the capital of xyz")),
                  child: BlinkAnimation(
                      key: rippleKey,
                      child: Container(
                          margin: EdgeInsets.only(left: 70, right: 70),
                          child: Text(
                            "Is the capital of xyz dgbdrgderhirf fderf  erre er er e er re r e",
                            textAlign: TextAlign.center,
                          ))),
                ))),
        Container(
          height: 100,
          width: double.infinity,
          color: Color(0xFFF46565),
        ),
      ],
    ));
  }
}
