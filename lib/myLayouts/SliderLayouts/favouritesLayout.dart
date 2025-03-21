import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:inotes/Authentication/loginPage.dart';
import 'package:inotes/myLayouts/EditNoteLayout.dart';

import '../../NoteClass/Note.dart';

class favouriteLayout extends StatefulWidget {

  final List<Note> Notes;

  const favouriteLayout({
    super.key,
    required this.Notes,
  });


  @override
  State<favouriteLayout> createState() => _favouriteLayoutState();
}

class _favouriteLayoutState extends State<favouriteLayout> {
  List<Map<String, dynamic>> notes = [];
  List<Note> favNotes = [];

  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {

    super.initState();
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please login again.")),
      );
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => loginPage()));
    } else {
      getFavNotes(); // Fetch favorite notes when the screen loads
    }
  }

  void showColorPickerForNote(int index) {
    Color tempColor = favNotes[index].color;
    String noteId = notes[index]["id"]; // Get the note ID from Firestore
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Pick a Color for Note"),
          content: SingleChildScrollView(
            child: MaterialPicker(
              pickerColor: tempColor,
              onColorChanged: (color) {
                tempColor = color;
              },
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: ColorScheme.of(context).onPrimary
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                  backgroundColor: ColorScheme.of(context).onPrimary
              ),
              onPressed: () async {
                // Update the note color locally and in Firestore
                setState(() {
                  favNotes[index].color = tempColor;
                });

                try {
                  await firebaseFirestore
                      .collection("iNotes")
                      .doc(user?.uid)
                      .collection("FavNotes")
                      .doc(noteId)
                      .update({"color": tempColor.value});
                }
                on FirebaseException catch (e){
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(e.code)),
                  );
                }
                catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Failed to update color: $e")),
                  );
                }

                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> getFavNotes() async {
    try {
      QuerySnapshot noteSnapshot = await firebaseFirestore
          .collection("iNotes")
          .doc(user?.uid)
          .collection("FavNotes")
          .get();

      notes = noteSnapshot.docs.map((doc) {
        return {
          "id": doc.id,
          "data": doc.data(),
        };
      }).toList();

      favNotes = noteSnapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        return Note(
          data["title"] ?? "",
          data["description"] ?? "",
          Color(data["color"] ?? 0xFFFFFFFF),
        );
      }).toList();

      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch favorite notes: $e")),
      );
    }
  }

  void onDeleteFavNotePressed(int index) async {
    String noteId = notes[index]["id"];
    try {
      await firebaseFirestore
          .collection("iNotes")
          .doc(user?.uid)
          .collection("FavNotes")
          .doc(noteId)
          .delete();

      setState(() {
        getFavNotes();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Favorite note deleted successfully.")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete favorite note: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      backgroundColor: ColorScheme.of(context).onPrimary,
      color: ColorScheme.of(context).primary,
      onRefresh: () async {
        await getFavNotes();
      },
      child: ListView.builder(
        itemCount: favNotes.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditNoteLayout(
                    initialTitle: favNotes[index].title,
                    initialDescription: favNotes[index].description,
                    initialColor: favNotes[index].color,
                    noteId: notes[index]["id"],
                    isFav: true,
                  ),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.all(6),
              child: Slidable(
                closeOnScroll: true,
                key: ValueKey(index),
                startActionPane: ActionPane(
                  motion: ScrollMotion(),
                  children: [
                    // Delete Action
                    SlidableAction(
                      autoClose: true,
                      borderRadius: BorderRadius.circular(10),
                      onPressed: (context) {
                        onDeleteFavNotePressed(index);
                      },
                      backgroundColor: Color(0xFFFE4A49),
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Delete',
                    ),
                  ],
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: ColorScheme.of(context).primary,
                  ),
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(
                      favNotes[index].title,
                      style: TextStyle(
                        color: ColorScheme.of(context).onPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      maxLines: 2,
                    ),
                    subtitle: Text(
                      favNotes[index].description,
                      style: TextStyle(
                        color: ColorScheme.of(context).onPrimary,
                        fontSize: 15,
                      ),
                      maxLines: 1,
                    ),
                    trailing: InkWell(
                      onTap: () {
                        showColorPickerForNote(index);
                      },
                      child: Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: favNotes[index].color,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}