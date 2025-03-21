import 'package:flutter/material.dart';

class NewNoteDescriptionLayout extends StatelessWidget {
  final TextEditingController descriptionController;

  const NewNoteDescriptionLayout({
    Key? key,
    required this.descriptionController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextFormField(
        cursorColor: ColorScheme.of(context).onPrimary,
          controller: descriptionController,
          keyboardType: TextInputType.multiline,
          style: TextStyle(color: ColorScheme.of(context).onPrimary),
          maxLines: 14,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            suffixIcon: IconButton(onPressed: (){descriptionController.text = "";}, icon: Icon(Icons.clear_rounded)),
              labelText: 'Description',
              labelStyle: TextStyle(
                color: ColorScheme.of(context).onPrimary,
              ),
              floatingLabelStyle: TextStyle(
                color: ColorScheme.of(context).onPrimary,
                fontWeight: FontWeight.bold,
              ),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 2,
                      color: ColorScheme.of(context).onPrimary
                  )
              )
          )
      ),
    );
  }
}
