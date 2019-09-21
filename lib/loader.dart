import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Loader extends StatefulWidget {
  @override
  LoaderAnimationWidgetState createState() => LoaderAnimationWidgetState();
}

class LoaderAnimationWidgetState extends State<Loader>
    with TickerProviderStateMixin {

  AnimationController _controller;
  Animation _animation;
  bool appState = false;
  double width;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    _controller.forward();
    if(!appState) {
      return _triggerLoader;
    }
    return _loadView;
  }

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    _animation = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    ))..addStatusListener(handler);
  }

  void handler(status) {
    if (status == AnimationStatus.completed) {
      _animation.removeStatusListener(handler);
      _controller.reset();
      _animation = Tween(begin: 0.0, end: 11.0).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.fastOutSlowIn,
      ))..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            setState(() {
              appState = true;
            });
          }
        });
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget get _loadView {
    return Scaffold(
        body: Center(
          child: Text('Hello World'),
        ),
      );
  }

  Widget get _triggerLoader {
    return AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget child) {
          return Scaffold(
              body:  Transform(
                transform:
                Matrix4.translationValues(_animation.value * width, 0.0, 0.0),
                child: new Center(
                    child: Container(
                      width: 200.0,
                      height: 200.0,
                      color: Colors.blue,
                    )),
              )
          );
        });
  }
}
