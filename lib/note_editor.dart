import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes/app_style.dart';

class NoteEditorScreen extends StatefulWidget {
  final QueryDocumentSnapshot? note;

  const NoteEditorScreen({super.key, this.note});

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  /*String date = DateFormat('dd/MM/yyyy hh:mm a').format(DateTime.now());

  // String date = DateTime.now().toString();

  TextEditingController titleController = TextEditingController();
  TextEditingController mainController = TextEditingController();*/

  late String date;
  late TextEditingController titleController;
  late TextEditingController mainController;
  late int colorId;
  late String documentId;

  @override
  void initState() {
    super.initState();

    if (widget.note != null) {
      // Editing mode
      documentId = widget.note!.id;
      date = widget.note!['creation_date'];
      titleController = TextEditingController(text: widget.note!['note_title']);
      mainController =
          TextEditingController(text: widget.note!['note_content']);
      colorId = widget.note!['color_id'];
    } else {
      // Adding new note
      date = DateFormat('dd/MM/yyyy hh:mm a').format(DateTime.now());
      titleController = TextEditingController();
      mainController = TextEditingController();
      colorId = Random().nextInt(AppStyle.cardsColor.length);
    }
  }

  @override
  Widget build(BuildContext context) {
    int color_id = Random().nextInt(AppStyle.cardsColor.length);
    return Scaffold(
      backgroundColor: AppStyle.cardsColor[color_id],
      appBar: AppBar(
        // iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          widget.note != null ? "Edit Note" : "Add a new note",
          style: AppStyle.mainTitle,
        ),
        backgroundColor: AppStyle.cardsColor[color_id],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Note Title",
              ),
              style: AppStyle.mainTitle,
            ),
            const SizedBox(height: 8),
            Text(
              date,
              style: AppStyle.dateTitle,
            ),
            const SizedBox(height: 30),
            TextField(
              controller: mainController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: const InputDecoration(
                  border: InputBorder.none, hintText: "Note Content"),
              style: AppStyle.mainContent,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (widget.note != null) {
            await FirebaseFirestore.instance
                .collection("notes")
                .doc(documentId)
                .update({
              "note_title": titleController.text,
              "creation_date":
                  DateFormat('dd/MM/yyyy hh:mm a').format(DateTime.now()),
              "note_content": mainController.text,
              "color_id": colorId
            });
          } else {
            await FirebaseFirestore.instance.collection("notes").add({
              "note_title": titleController.text,
              "creation_date": date,
              "note_content": mainController.text,
              "color_id": colorId
            });
          }
          Navigator.pop(context);
        },
        backgroundColor: AppStyle.accentColor,
        child: const Icon(
          Icons.save,
          color: Colors.white,
        ),
      ),
    );
  }
}

/*FloatingActionButton(
        onPressed: () async {
          FirebaseFirestore.instance.collection("notes").add({
            "note_title": titleController.text,
            "creation_date": date,
            "note_content": mainController.text,
            "color_id": color_id
          }).then((value) {
            Navigator.pop(context);
          });
        },
        backgroundColor: AppStyle.accentColor,
        child: const Icon(
          Icons.save,
          color: Colors.white,
        ),
      ),
    );
  }
}*/
