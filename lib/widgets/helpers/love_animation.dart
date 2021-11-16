import 'package:flutter/material.dart';
import '../../utils/shared.dart';

class LoveAnimation extends StatefulWidget {
  @override
  _LoveAnimationState createState() => _LoveAnimationState();
}

class _LoveAnimationState extends State<LoveAnimation> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation colorAnimation;
  Animation sizeAnimation;
  bool isFav = false;
  bool iconBool = false;

  @override
  void initState() {
    super.initState();
    controller = new AnimationController(
        duration: Duration(milliseconds: 900),
        vsync: this
    );
    colorAnimation = ColorTween(begin: container, end: button).animate(controller);
    sizeAnimation = TweenSequence(
        <TweenSequenceItem<double>>
        [
          TweenSequenceItem<double>(
            tween: Tween<double>(begin: 50, end: 100),
            weight: 50,
          ),
          TweenSequenceItem<double>(
            tween: Tween<double>(begin: 100, end: 50),
            weight: 50,
          ),
        ]
    ).animate(controller);
    controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, _) {
        return IconButton(
            icon: Icon(Icons.favorite,size: sizeAnimation.value,color: colorAnimation.value,),
            onPressed: (){
            }
        );
      },
    );
  }

}

