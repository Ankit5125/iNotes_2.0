import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:inotes/Authentication/sigUpPage.dart';

import '../../Authentication/loginPage.dart';

class ChooseOptionScreen extends StatefulWidget {
  const ChooseOptionScreen({super.key});

  @override
  State<ChooseOptionScreen> createState() => _ChooseOptionScreenState();
}

class _ChooseOptionScreenState extends State<ChooseOptionScreen> {
  double _opacity = 0;


  @override
  void initState() {

    super.initState();
    _startFading();
  }

  void _startFading() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _opacity = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          // Wrap with SingleChildScrollView
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 50,
                ),
                AnimatedOpacity(
                  opacity: _opacity,
                  duration: Duration(seconds: 1),
                  child: SizedBox(
                    height: 300,
                    width: 275,
                    child: Image.asset("assets/images/door.jpg"),
                  ),
                ),
                Container(
                  height: 50,
                ),
                Container(
                  width: 250,
                  height: 58,
                  decoration: BoxDecoration(
                    color: ColorScheme.of(context).primary,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      width: 2,
                      color: ColorScheme.of(context).onPrimary,
                    ),
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorScheme.of(context).primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      )
                    ),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => loginPage()));
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: ColorScheme.of(context).onPrimary
                      ),

                    ),
                  ),
                ),
                Container(
                  height: 20,
                ),
                Container(
                  width: 250,
                  height: 58,
                  decoration: BoxDecoration(
                    color: ColorScheme.of(context).onPrimary,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      width: 2,
                      color: ColorScheme.of(context).primary,
                    ),
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorScheme.of(context).onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => signUpPage()));
                    },
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: ColorScheme.of(context).primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
