import 'package:flutter/material.dart';
import 'package:quiz_app/utils/app_colors.dart';

class BlinkAnimation extends StatefulWidget {
  const BlinkAnimation({super.key, required this.child});

  final Widget child;

  @override
  State<BlinkAnimation> createState() => BlinkAnimationState();
}

// State is not private because used for GlobalKey in GameScreen
class BlinkAnimationState extends State<BlinkAnimation>
    with SingleTickerProviderStateMixin {
  late Animation<Color?> animationGreen;
  late Animation<Color?> animationRed;
  late AnimationController controller;
  late bool isWrong;

  final colors = <TweenSequenceItem<Color?>>[
    TweenSequenceItem(
        tween: ColorTween(begin: Colors.white, end: AppColors.falseColor),
        weight: 1),
    TweenSequenceItem(
        tween: ColorTween(begin: AppColors.falseColor, end: Colors.white),
        weight: 1),
    TweenSequenceItem(
        tween: ColorTween(begin: Colors.white, end: AppColors.falseColor),
        weight: 1),
    TweenSequenceItem(
        tween: ColorTween(begin: AppColors.falseColor, end: Colors.white),
        weight: 1),
  ];

  @override
  initState() {
    super.initState();
    isWrong = false;
    controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    final CurvedAnimation curve =
        CurvedAnimation(parent: controller, curve: Curves.easeInOutBack);
    animationGreen = ColorTween(begin: Colors.white, end: AppColors.trueColor)
        .animate(curve);
    animationRed = TweenSequence<Color?>(colors).animate(controller);

    controller.addListener(() {
      setState(() {});
    });

    animationGreen.addStatusListener((status) {
      // Reset the animation after it has been completed
      if (status == AnimationStatus.completed) {
        controller.reset();
      }
    });
  }

  void startAnimation() {
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: animationGreen,
        builder: (BuildContext context, Widget? child) {
          return Flex(
            mainAxisAlignment: MainAxisAlignment.center,
            direction: Axis.vertical,
            children: <Widget>[
              Expanded(
                child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: isWrong ? animationRed.value : animationGreen.value,
                    child: Row(children: [
                      Expanded(
                        child: Center(child: widget.child),
                      ),
                    ])),
              )
            ],
          );
        },
      ),
    );
  }

  @override
  dispose() {
    controller.dispose();
    super.dispose();
  }
}
