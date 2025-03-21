import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:inotes/Authentication/loginPage.dart';
import 'package:inotes/NoteClass/Note.dart';
import 'package:inotes/myLayouts/BeforeLoginLayouts/chooseOption.dart';
import 'package:inotes/myLayouts/SliderLayouts/changePassword.dart';
import 'package:inotes/myLayouts/SliderLayouts/favouritesLayout.dart';
import 'package:inotes/myLayouts/SliderLayouts/homeLayout.dart';
import 'package:inotes/myLayouts/SliderLayouts/logoutLayout.dart';
import 'package:inotes/myLayouts/bottomSheetLayouts/bottomSheetDescriptionLayout.dart';
import 'package:inotes/myLayouts/bottomSheetLayouts/bottomSheetTitleLayout.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'iNotes',
        theme: ThemeData(
          colorScheme: ColorScheme.light(
            primary: const Color(0xFFF3E4CF),
            onPrimary: const Color(0xFF5E2C0D),

          ),
          useMaterial3: true,
        ),
        home: (user != null)
            ? MyHomePage(title: "iNotes")
            : ChooseOptionScreen());
  }

  Future<bool> checkIfAccountExists(String uid) async {
    // Replace this logic with your database query
    final userDoc =
    await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return userDoc.exists;
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  final GlobalKey<SliderDrawerState> _sliderDrawerKey =
  GlobalKey<SliderDrawerState>();
  String title = "iNotes";

  List<Note> Notes = [
    Note("Slide This to see more Feature ➡️",
        "Choose Color to make Note Special", Color(0xFF5E2C0D))
  ];

  List<Note> FavNotes = [
    Note("Slide This to see more Feature ➡️",
        "Choose Color to make Note Special", Color(0xFF5E2C0D))
  ];

  var titleController = TextEditingController();
  var descriptionController = TextEditingController();

  int selected = 0;
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void closeSideBar() {
    _sliderDrawerKey.currentState?.closeSlider();
  }

  @override
  void initState() {
    // TODO: implement initState
    if (user == null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => loginPage()));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: _showBottomSheet,
          child: Icon(Icons.add),
        ),
        body: SliderDrawer(
            key: _sliderDrawerKey,
            isDraggable: false,
            appBar: SliderAppBar(
              config: SliderAppBarConfig(
                drawerIconColor: Theme.of(context).colorScheme.primary,
                backgroundColor: Theme.of(context).colorScheme.onPrimary,
                title: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFF3E4CF),
                  ),
                ),
              ),
            ),
            sliderOpenSize: 250,
            slider: slideBar(),
            child: HomeScreen()),
      ),
    );
  }

  Widget HomeScreen() {
    if (selected == 0) {
      closeSideBar();
      return homeLayout();
    } else if (selected == 1) {
      closeSideBar();
      return favouriteLayout(
        Notes: FavNotes,
      );
    } else if (selected == 3) {
      closeSideBar();
      return changePasswordLayout();
    } else {
      closeSideBar();
      return LogoutLayout();
    }
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: ColorScheme.of(context).primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            NewNoteTitleLayout(titleController: titleController),
            NewNoteDescriptionLayout(
                descriptionController: descriptionController),
            SizedBox(height: 20),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              onPressed: () {
                if (titleController.text.isNotEmpty &&
                    descriptionController.text.isNotEmpty) {
                  setState(() {
                    addNoteToFirebase(
                        titleController.text,
                        descriptionController.text,
                        ColorScheme.of(context).onPrimary,
                        user!.uid);
                  });

                  titleController.text = "";
                  descriptionController.text = "";

                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Please Enter Valid Inputs",
                      ),
                    ),
                  );
                }
              },
              child: Text("Add"),
            ),
          ],
        );
      },
      showDragHandle: true,
      isDismissible: false,
      isScrollControlled: true,
    );
  }

  Widget slideBar() {
    return SafeArea(
      child: Container(
        height: double.infinity,
        width: double.infinity,
        color: ColorScheme.of(context).primary,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            Column(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 50,
                    ),
                    Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        color: ColorScheme.of(context).onPrimary,
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(6), // Add padding
                        child: ClipOval(
                          child: Image.asset(
                            "assets/images/inotes_logo.png",
                            fit: BoxFit.cover, // Ensures the image fills the circle
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 20,
                    ),
                    Text(
                      user!.email.toString(),
                      style: TextStyle(
                          color: ColorScheme.of(context).onPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w800),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Divider(
                        color: ColorScheme.of(context).onPrimary,
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: isSelected(selected, 0)
                            ? ColorScheme.of(context).onPrimary
                            : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        )),
                    onPressed: () {
                      setState(() {
                        selected = 0;
                      });
                    },
                    child: ListTile(
                      leading: Icon(
                        Icons.home,
                        color: isSelected(selected, 0)
                            ? ColorScheme.of(context).primary
                            : ColorScheme.of(context).onPrimary,
                      ),
                      title: Text(
                        "Home",
                        style: TextStyle(
                            color: isSelected(selected, 0)
                                ? ColorScheme.of(context).primary
                                : ColorScheme.of(context).onPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: isSelected(selected, 1)
                            ? ColorScheme.of(context).onPrimary
                            : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        )),
                    onPressed: () {
                      setState(() {
                        selected = 1;
                      });
                    },
                    child: ListTile(
                      leading: Icon(
                        Icons.push_pin,
                        color: isSelected(selected, 1)
                            ? ColorScheme.of(context).primary
                            : ColorScheme.of(context).onPrimary,
                      ),
                      title: Text(
                        "Favourite",
                        style: TextStyle(
                            color: isSelected(selected, 1)
                                ? ColorScheme.of(context).primary
                                : ColorScheme.of(context).onPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: isSelected(selected, 3)
                            ? ColorScheme.of(context).onPrimary
                            : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        )),
                    onPressed: () {
                      setState(() {
                        selected = 3;
                      });
                    },
                    child: ListTile(
                      leading: Icon(
                        Icons.password,
                        color: isSelected(selected, 3)
                            ? ColorScheme.of(context).primary
                            : ColorScheme.of(context).onPrimary,
                      ),
                      title: Text(
                        "Change Password",
                        style: TextStyle(
                            color: isSelected(selected, 3)
                                ? ColorScheme.of(context).primary
                                : ColorScheme.of(context).onPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: isSelected(selected, 4)
                            ? ColorScheme.of(context).onPrimary
                            : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        )),
                    onPressed: () {
                      setState(() {
                        selected = 4;
                      });
                    },
                    child: ListTile(
                      leading: Icon(
                        Icons.logout,
                        color: isSelected(selected, 4)
                            ? ColorScheme.of(context).primary
                            : ColorScheme.of(context).onPrimary,
                      ),
                      title: Text(
                        "Logout",
                        style: TextStyle(
                            color: isSelected(selected, 4)
                                ? ColorScheme.of(context).primary
                                : ColorScheme.of(context).onPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 10,
                )
              ],
            ),

            Text(
              "Made by Ankit\n",
              style: TextStyle(
                  color: ColorScheme.of(context).onPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
    );
  }

  bool isSelected(selected, currentButton) {
    if (selected == currentButton) {
      return true;
    } else {
      return false;
    }
  }

  void addNoteToFirebase(
      String title, String description, Color color, String userId) async {
    try {
      String noteId = firebaseFirestore
          .collection("iNotes")
          .doc(userId)
          .collection("Notes")
          .doc()
          .id;

      await firebaseFirestore
          .collection("iNotes") // Main collection
          .doc(userId) // User-specific document
          .collection("Notes") // Sub-collection
          .doc(noteId) // Document ID for the note
          .set({
        'title': title,
        'description': description,
        'color': color.value, // Save color as integer
        'createdAt': FieldValue.serverTimestamp(), // Timestamp for sorting
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Note Added Successfully",
          ),
        ),
      );
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.code),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Something Went Wrong Please Try Again",
          ),
        ),
      );
    }
  }
}
