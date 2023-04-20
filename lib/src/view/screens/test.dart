import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app/src/view/widgets/ripple.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlinkAnimation(child: Text("yes"));
  }
}
