import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inotes/myLayouts/BeforeLoginLayouts/chooseOption.dart';

class LogoutLayout extends StatelessWidget {
  const LogoutLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              "Are you Sure ?",
              style: TextStyle(
                  color: ColorScheme.of(context).onPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 22),
            ),
          ),
          Container(
            height: 10,
          ),
          Center(
            child: Text(
              "You Want to Logout ??",
              style: TextStyle(
                  color: ColorScheme.of(context).onPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 25),
            ),
          ),

          Container(height: 50,),
          Center(
            child: SizedBox(

              height: 45,
              width: 200,

              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorScheme.of(context).onPrimary
                ),
                onPressed: () async {

                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ChooseOptionScreen())).then((_){void setSystemUIOverlayStyle(BuildContext context) {
                    SystemChrome.setSystemUIOverlayStyle(
                      SystemUiOverlayStyle(
                        statusBarColor: Colors.transparent, // Transparent status bar
                        statusBarIconBrightness: Brightness.dark, // Dark icons for status bar
                        systemNavigationBarColor: Theme.of(context).colorScheme.primary, // Navigation bar color
                        systemNavigationBarIconBrightness: Brightness.dark, // Dark icons for navigation bar
                      ),
                    );
                  }});

                },
                child: Text(
                  "Logout",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: ColorScheme.of(context).primary,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
