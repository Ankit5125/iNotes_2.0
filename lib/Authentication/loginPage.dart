import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:inotes/Authentication/forgetPassword.dart';
import 'package:inotes/Authentication/sigUpPage.dart';
import 'package:inotes/main.dart';

class loginPage extends StatefulWidget {
  const loginPage({super.key});

  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  bool showCircularProgressBar = false;
  late FirebaseAuth _auth;
  var _opecity = 0.0;

  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  bool _isEmailFocused = false;
  bool _isPasswordFocused = false;
  bool showPassword = true;

  @override
  void initState() {
    _auth = FirebaseAuth.instance;

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
    startFading();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void startFading() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _opecity = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorScheme.of(context).primary,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 50,
                ),
                AnimatedOpacity(
                  opacity: _opecity,
                  duration: Duration(seconds: 1),
                  child: Container(
                    height: 300,
                    width: 275,
                    child: Image.asset("assets/images/login_image.png"),
                  ),
                ),
                Container(
                  height: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome Back !",
                      style: TextStyle(
                          color: ColorScheme.of(context).onPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 38),
                    ),
                    Text(
                      "Glad to See You Again...",
                      style: TextStyle(
                          color: ColorScheme.of(context).onPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ],
                ),
                Container(
                  height: 20,
                ),
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
                Container(
                  height: 10,
                ),
                SizedBox(
                  width: 260,
                  child: TextFormField(

                    cursorColor: ColorScheme.of(context).onPrimary,
                    obscureText: showPassword,
                    controller: passwordController,
                    keyboardType: TextInputType.emailAddress,
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
                    ), // Set the background color for selected text
                  ),
                ),

                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => forgetPassword()));
                  },
                  child: Text(
                    "Forget Password ?",
                    style: TextStyle(
                        color: ColorScheme.of(context).onPrimary,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  height: 20,
                ),
                // Add this widget under the "Login" button in the build method:

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
                    onPressed: _isLoading ? null : () { tryToLogin(); }, // Disable button when loading
                    child: _isLoading
                        ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(ColorScheme.of(context).primary), // Color for progress bar
                    )
                        : Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: ColorScheme.of(context).primary,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => signUpPage()));
                  },
                  child: Text(
                    "Don't Have Account ? SignUp",
                    style: TextStyle(
                        color: ColorScheme.of(context).onPrimary,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _isLoading = false; // Add a loading state variable

  Future<void> tryToLogin() async {
    String email = emailController.text;
    String password = passwordController.text;

    if (email.isNotEmpty && password.isNotEmpty) {
      setState(() {
        _isLoading = true; // Start loading
      });

      try {
        final UserCredential userCredential = await _auth
            .signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        User? user = userCredential.user;

        setState(() {
          _isLoading = false; // Stop loading after the process completes
        });

        if (user != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Login Successful",
              ),
            ),
          );
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) =>
                  MyHomePage(
                    title: "iNotes",
                  ),
            ),
          );
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          _isLoading = false; // Stop loading on exception
        });

        if (e.code == 'user-not-found') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("No user found for that email."),
            ),
          );
        } else if (e.code == 'wrong-password') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Wrong Password!"),
            ),
          );
        }
        else if(e.code == 'invalid-credential'){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Wrong Password!"),
            ),
          );
        }
        else{
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              // content: Text("Wrong Password / Account Not Exist"),
              content: Text(e.code),
            ),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please Enter Valid Data"),
        ),
      );
    }
  }
}
