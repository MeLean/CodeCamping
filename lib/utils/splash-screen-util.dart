import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

Widget _home;
Function _customFunction;
String _title;
String _subTitle;
int _duration;
AnimatedSplashType _runfor;
Color _backgroundColor;

enum AnimatedSplashType { StaticDuration, BackgroundProcess }

Map<dynamic, Widget> _outputAndHome = {};

class AnimatedSplash extends StatefulWidget {
  AnimatedSplash(
      {@required String title,
      @required Widget home,
      String subTitle,
      Color backgroundColor,
      Function customFunction,
      int duration,
      AnimatedSplashType type,
      Map<dynamic, Widget> outputAndHome}) {
    assert(duration != null);
    assert(home != null);
    assert(title != null);

    _home = home;
    _subTitle = subTitle;
    _duration = duration;
    _customFunction = customFunction;
    _title = title;
    _runfor = type;
    _outputAndHome = outputAndHome;
    _backgroundColor = backgroundColor;
  }

  @override
  _AnimatedSplashState createState() => _AnimatedSplashState();
}

class _AnimatedSplashState extends State<AnimatedSplash>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation _animation;

  @override
  void initState() {
    super.initState();
    if (_duration < 1000) _duration = 2000;
    _animationController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 800));
    _animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.easeInCirc));
    _animationController.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.reset();
  }

  navigator(home) {
    Navigator.of(context).pushReplacement(
        CupertinoPageRoute(builder: (BuildContext context) => home));
  }

  @override
  Widget build(BuildContext context) {
    _runfor == AnimatedSplashType.BackgroundProcess
        ? Future.delayed(Duration.zero).then((value) {
            var res = _customFunction();
            //print("$res+${_outputAndHome[res]}");
            Future.delayed(Duration(milliseconds: _duration)).then((value) {
              Navigator.of(context).pushReplacement(CupertinoPageRoute(
                  builder: (BuildContext context) => _outputAndHome[res]));
            });
          })
        : Future.delayed(Duration(milliseconds: _duration)).then((value) {
            Navigator.of(context).pushReplacement(
                CupertinoPageRoute(builder: (BuildContext context) => _home));
          });

    return Scaffold(
      backgroundColor: _backgroundColor,
      body: FadeTransition(
        opacity: _animation,
        child: Center(
          child: SizedBox(
            height: 250.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  _title,
                  style: TextStyle(
                      fontSize: 24.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w700),
                ),
                Text(
                  _subTitle,
                  style: TextStyle(fontSize: 18.0, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
