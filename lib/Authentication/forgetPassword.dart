import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inotes/Authentication/loginPage.dart';
import 'package:inotes/Authentication/sigUpPage.dart';

class forgetPassword extends StatefulWidget {
  const forgetPassword({super.key});

  @override
  State<forgetPassword> createState() => _forgetPasswordState();
}

class _forgetPasswordState extends State<forgetPassword> {
  var _opecity = 0.0;
  var emailController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  bool _isEmailFocused = false;
  bool _isLoading = false;

  @override
  void initState() {

    _emailFocusNode.addListener(() {
      setState(() {
        _isEmailFocused = _emailFocusNode.hasFocus;
      });
    });
    startFading();
  }

  @override
  void dispose() {
    emailController.dispose();
    _emailFocusNode.dispose();
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
                    child: Image.asset("assets/images/forget_password.png"),
                  ),
                ),
                Container(
                  height: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Forgot Password ?",
                      style: TextStyle(
                          color: ColorScheme.of(context).onPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 38),
                    ),
                    Text(
                      "We're Here to Help You... ",
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
                  height: 28,
                ),
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
                    onPressed: _isLoading ? null : () { tryToResetPassword(); }, // Disable button when loading
                    child: _isLoading
                        ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(ColorScheme.of(context).primary), // Color for progress bar
                    )
                        : Text(
                      'Send Email',
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

  void tryToResetPassword() async {

    setState(() {
      _isLoading = true;
    });

    String email = emailController.text;

    if (email.isNotEmpty) {
      try{
        List<String> methods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);

        if(methods.isNotEmpty){

          await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Password Reset Email Sent"),
            ),
          );
        }
        else{
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("User Not Exist..."),
            ),
          );

          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => signUpPage()));
        }

      }
      on FirebaseAuthException catch (e){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.code),
          ),
        );
      }
      setState(() {
        _isLoading = false;
      });
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please Enter Valid Email ID"),
        ),
      );

      setState(() {
        _isLoading = false;
      });
    }
  }
}
