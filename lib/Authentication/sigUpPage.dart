import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inotes/Authentication/loginPage.dart';

class signUpPage extends StatefulWidget {
  @override
  State<signUpPage> createState() => _signUpPageState();
}

class _signUpPageState extends State<signUpPage> {
  double _opacity = 0.0;
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  bool _isEmailFocused = false;
  bool _isPasswordFocused = false;
  bool showPassword = true;
  bool _isLoading = false;


  @override
  void initState() {

    super.initState();
    _emailFocusNode.addListener(() {
      setState(() {
        _isEmailFocused = _emailFocusNode.hasFocus;
      });
    });
    _passwordFocusNode.addListener(() {
      setState(() {
        _isPasswordFocused = _emailFocusNode.hasFocus;
      });
    });
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
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          ColorScheme.of(context).primary, // Replace with your color
      body: SingleChildScrollView(
        // Make the content scrollable
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(
                16.0), // Add padding to avoid content touching the edges
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
                    child: Image.asset("assets/images/signup_image.png"),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Hello',
                  style: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.bold,
                    color: ColorScheme.of(context).onPrimary,
                  ),
                ),
                Text(
                  'Register to get started',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: ColorScheme.of(context).onPrimary,
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: 260,
                  child: TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    focusNode: _emailFocusNode,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(
                        color: ColorScheme.of(context).onPrimary,
                      ),
                      floatingLabelStyle: TextStyle(
                        color: _emailFocusNode.hasFocus
                            ? ColorScheme.of(context).onPrimary
                            : Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 3,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: ColorScheme.of(context).onPrimary,
                          width: 3,
                        ),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          emailController.text = "";
                        },
                        icon: Icon(Icons.clear),
                        color: ColorScheme.of(context).onPrimary,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  width: 260,
                  child: TextFormField(
                    controller: passwordController,
                    obscureText: showPassword,
                    focusNode: _passwordFocusNode,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(
                        color: ColorScheme.of(context).onPrimary,
                      ),
                      floatingLabelStyle: TextStyle(
                        color: _passwordFocusNode.hasFocus
                            ? ColorScheme.of(context).onPrimary
                            : Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 3,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: ColorScheme.of(context).onPrimary,
                          width: 3,
                        ),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            showPassword = !showPassword;
                          });
                        },
                        icon: showPassword
                            ? Icon(Icons.lock)
                            : Icon(Icons.lock_open),
                        color: ColorScheme.of(context).onPrimary,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 28),
                SizedBox(
                  width: 250,
                  height: 58,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorScheme.of(context).onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: _isLoading
                        ? null
                        : () {
                            tryToSignUp();
                          }, // Disable button when loading
                    child: _isLoading
                        ? CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                ColorScheme.of(context)
                                    .primary), // Color for progress bar
                          )
                        : Text(
                            'SignUp',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: ColorScheme.of(context).primary,
                            ),
                          ),
                  ),
                ),
                SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => loginPage()));
                  },
                  child: Text(
                    'Already have an account? Login',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: ColorScheme.of(context).onPrimary,
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

  void tryToSignUp() async {
    String email = emailController.text;
    String password = passwordController.text;

    if (email.isNotEmpty && password.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });

      try {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Account Created Successfully")));

        setState(() {
          _isLoading = false;
        });

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => loginPage()));
      } on FirebaseAuthException catch (e) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.code,
            ),
          ),
        );
      }

    }
  }
}
