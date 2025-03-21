import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inotes/myLayouts/bottomSheetLayouts/bottomSheetTitleLayout.dart';

import '../../Authentication/loginPage.dart';

class changePasswordLayout extends StatefulWidget {
  changePasswordLayout({super.key});

  @override
  State<changePasswordLayout> createState() => _changePasswordLayoutState();
}

class _changePasswordLayoutState extends State<changePasswordLayout> {
  var newPass = TextEditingController();
  var retypePass = TextEditingController();

  // Add a state for tracking password visibility
  bool newPassVisible = false;
  bool retypePassVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 20,
          ),
          passwordField(context, newPass, 'Enter New Password', newPassVisible,
              (value) {
            setState(() {
              newPassVisible = value;
            });
          }),
          passwordField(
              context, retypePass, 'Retype New Password', retypePassVisible,
              (value) {
            setState(() {
              retypePassVisible = value;
            });
          }),
          Container(
            height: 20,
          ),
          Center(
            child: Container(
              height: 55,
              width: 125,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorScheme.of(context).onPrimary,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Save",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: ColorScheme.of(context).primary),
                    ),
                    Container(
                      width: 10,
                    ),
                    Icon(Icons.cloud_upload)
                  ],
                ),
                onPressed: () {
                  changePassword();
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  void changePassword() async {
    String NEWPASS = newPass.text;
    String RETYPENEWPASS = retypePass.text;

    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        if (NEWPASS == RETYPENEWPASS) {
          await user.updatePassword(NEWPASS);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Password updated successfully')),
          );
          newPass.text = "";
          retypePass.text = "";
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Password And Confirm Passwords are Not Matching...",
              ),
            ),
          );
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'requires-recent-login') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Please Login Again",
              ),
            ),
          );

          await FirebaseAuth.instance.signOut();

          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => loginPage()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.code),
            ),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "User Not Found Please Login Again",
          ),
        ),
      );

      await FirebaseAuth.instance.signOut();

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => loginPage()));
    }
  }

  Widget passwordField(
    BuildContext context,
    TextEditingController controller,
    String label,
    bool isPasswordVisible,
    ValueChanged<bool> onVisibilityChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextFormField(
        obscureText: !isPasswordVisible,
        cursorColor: ColorScheme.of(context).onPrimary,
        controller: controller,
        keyboardType: TextInputType.text,
        style: TextStyle(
            color: ColorScheme.of(context).onPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          suffixIcon: IconButton(
            onPressed: () {
              onVisibilityChanged(!isPasswordVisible); // Toggle visibility
            },
            icon: Icon(
              isPasswordVisible
                  ? Icons.lock_open
                  : Icons.lock, // Update the icon
            ),
          ),
          labelText: label,
          labelStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: ColorScheme.of(context).onPrimary,
          ),
          floatingLabelStyle: TextStyle(
            color: ColorScheme.of(context).onPrimary,
            fontWeight: FontWeight.bold,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: ColorScheme.of(context).onPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
