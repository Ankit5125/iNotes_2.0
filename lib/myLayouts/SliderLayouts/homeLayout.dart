import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:inotes/Authentication/loginPage.dart';
import 'package:inotes/myLayouts/EditNoteLayout.dart';

import '../../NoteClass/Note.dart';

class homeLayout extends StatefulWidget {
  @override
  State<homeLayout> createState() => _homeLayoutState();
}

class _homeLayoutState extends State<homeLayout> {
  List<Map<String, dynamic>> notes = [];
  List<Note> Notes = [];

  final User? user = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;



  @override
  void initState() {

    super.initState();
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please Login Again")),
      );
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => loginPage()));
    } else {
      getNotes(); // Fetch notes when the screen loads
    }
  }

  void showColorPickerForNote(int index) {
    Color tempColor = Notes[index].color;
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
                  backgroundColor: ColorScheme.of(context).onPrimary),
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                  backgroundColor: ColorScheme.of(context).onPrimary),
              onPressed: () async {
                // Update the note color locally and in Firestore
                setState(() {
                  Notes[index].color = tempColor;
                });

                try {
                  await firebaseFirestore
                      .collection("iNotes")
                      .doc(user?.uid)
                      .collection("Notes")
                      .doc(noteId)
                      .update({"color": tempColor.value});
                } on FirebaseException catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(e.code)),
                  );
                } catch (e) {
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

  Future<void> getNotes() async {
    try {
      QuerySnapshot noteSnapshot = await firebaseFirestore
          .collection("iNotes")
          .doc(user?.uid)
          .collection("Notes")
          .get();

      notes = noteSnapshot.docs.map((doc) {
        return {
          "id": doc.id,
          "data": doc.data(),
        };
      }).toList();

      Notes = noteSnapshot.docs.map((doc) {
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
        SnackBar(content: Text("Failed to fetch notes: $e")),
      );
    }
  }

  void onDeleteNotePressed(int index) async {
    String noteId = notes[index]["id"];
    try {
      await firebaseFirestore
          .collection("iNotes")
          .doc(user?.uid)
          .collection("Notes")
          .doc(noteId)
          .delete();

      setState(() {
        getNotes();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Note Deleted Successfully")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete note: $e")),
      );
    }
  }

  void addNoteToFavourites(
      String title, String description, Color color, String userId) async {
    try {
      String noteId = firebaseFirestore
          .collection("iNotes")
          .doc(userId)
          .collection("FavNotes")
          .doc()
          .id;

      await firebaseFirestore
          .collection("iNotes") // Main collection
          .doc(userId) // User-specific document
          .collection("FavNotes") // Sub-collection
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
            "Note Added To Favourites",
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

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      backgroundColor: ColorScheme.of(context).onPrimary,
      onRefresh: () async {
        await getNotes(); // Reload notes on pull-to-refresh
      },
      child: ListView.builder(
        itemCount: Notes.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditNoteLayout(
                    initialTitle: Notes[index].title,
                    initialDescription: Notes[index].description,
                    initialColor: Notes[index].color,
                    noteId: notes[index]["id"],
                    isFav: false,
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
                        onDeleteNotePressed(index);
                      },
                      backgroundColor: Color(0xFFFE4A49),
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Delete',
                      padding: EdgeInsets.all(10),
                    ),
                    SizedBox(width: 10),
                    // Add to Favorites Action
                    SlidableAction(
                      autoClose: true,
                      borderRadius: BorderRadius.circular(10),
                      onPressed: (context) {
                        addNoteToFavourites(
                            Notes[index].title,
                            Notes[index].description,
                            Notes[index].color,
                            user!.uid);
                      },
                      backgroundColor: Color(0xFF21B7CA),
                      foregroundColor: Colors.white,
                      icon: Icons.push_pin,
                      label: 'Favourite',
                      padding: EdgeInsets.all(10),
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
                      Notes[index].title,
                      style: TextStyle(
                        color: ColorScheme.of(context).onPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      maxLines: 2,
                    ),
                    subtitle: Text(
                      Notes[index].description,
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
                          color: Notes[index].color,
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
