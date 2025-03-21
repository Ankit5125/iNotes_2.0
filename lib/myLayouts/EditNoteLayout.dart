import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:inotes/main.dart';
import 'bottomSheetLayouts/bottomSheetDescriptionLayout.dart';
import 'bottomSheetLayouts/bottomSheetTitleLayout.dart'; // Update import path

class EditNoteLayout extends StatefulWidget {
  final String initialTitle;
  final String initialDescription;
  final Color initialColor;
  final String noteId;
  final bool isFav;

  const EditNoteLayout({
    super.key,
    required this.initialTitle,
    required this.initialDescription,
    required this.initialColor,
    required this.noteId,
    required this.isFav
  });

  @override
  State<EditNoteLayout> createState() => _EditNoteLayoutState();
}

class _EditNoteLayoutState extends State<EditNoteLayout> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late Color _selectedColor;
  final User? user = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _descriptionController = TextEditingController(text: widget.initialDescription);
    _selectedColor = widget.initialColor;
  }

  void _showColorPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pick a color'),
        content: SingleChildScrollView(
          child: MaterialPicker(
            pickerColor: _selectedColor,
            onColorChanged: (color) => setState(() => _selectedColor = color),
          ),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: ColorScheme.of(context).onPrimary
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _updateNote() async {
    try {
      if(!widget.isFav){
        await _firestore
            .collection("iNotes")
            .doc(user?.uid)
            .collection("Notes")
            .doc(widget.noteId)
            .update({
          'title': _titleController.text,
          'description': _descriptionController.text,
          'color': _selectedColor.value,
        });
      }
      else{
        await _firestore
            .collection("iNotes")
            .doc(user?.uid)
            .collection("FavNotes")
            .doc(widget.noteId)
            .update({
          'title': _titleController.text,
          'description': _descriptionController.text,
          'color': _selectedColor.value,
        });
      }
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating note: $e')),
      );
    }
  }

  Future<void> _deleteNote() async {
    try {
      if(!widget.isFav){
        await _firestore
            .collection("iNotes")
            .doc(user?.uid)
            .collection("Notes")
            .doc(widget.noteId)
            .delete();
      }
      else{

        await _firestore
            .collection("iNotes")
            .doc(user?.uid)
            .collection("FavNotes")
            .doc(widget.noteId)
            .delete();
      }
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting note: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Note'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Custom Title Field
            NewNoteTitleLayout(titleController: _titleController),

            // Custom Description Field
            NewNoteDescriptionLayout(descriptionController: _descriptionController),

            // Color Picker
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListTile(
                title: Text(
                  'Note Color',
                  style: TextStyle(
                    color: ColorScheme.of(context).onPrimary,
                  ),
                ),
                trailing: InkWell(
                  onTap: _showColorPicker,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _selectedColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: ColorScheme.of(context).onPrimary,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: _deleteNote,
              child: const Text('Delete Note'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              onPressed: _updateNote,
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}