import 'package:flutter/material.dart';

class NewNoteTitleLayout extends StatelessWidget {
  final TextEditingController titleController;

  const NewNoteTitleLayout({
    Key? key,
    required this.titleController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: TextFormField(
          cursorColor: ColorScheme.of(context).onPrimary,
          controller: titleController,
          keyboardType: TextInputType.text,
          style: TextStyle(
              color: ColorScheme.of(context).onPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            suffixIcon: IconButton(
              onPressed: () {
                titleController.text = "";
              },
              icon: Icon(
                Icons.clear_rounded,
              ),
            ),
            labelText: 'Title',
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
      ),
    );
  }
}
