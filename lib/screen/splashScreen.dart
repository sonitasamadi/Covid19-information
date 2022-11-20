import '/screen/showCountries.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _handleSplash();
  }

  @override
  Widget build(BuildContext context) {
    _handleSplash(context);
    return Scaffold(
      backgroundColor: Colors.indigo,
      body: Center(
        child: Text(
          'covid19 information',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

void _handleSplash(BuildContext context) async {
  await Future.delayed(Duration(seconds: 2));

  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
    return ShowCountries();
  }));
}
