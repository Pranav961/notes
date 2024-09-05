import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes/app_style.dart';
import 'package:notes/note_editor.dart';
import 'package:notes/note_reader.dart';

import 'note_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.mainColor,
      appBar: AppBar(
        backgroundColor: AppStyle.mainColor,
        title: Text("Notes",
            style: GoogleFonts.chakraPetch(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 30)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Recent Notes",
              style: GoogleFonts.chakraPetch(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection("notes").snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasData) {
                    return GridView(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2),
                      children: snapshot.data!.docs
                          .map((note) => noteCard(
                                () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            NoteReaderScreen(note),
                                      ));
                                },
                                note,
                                () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text(
                                          "Are you sure want to delete this?",
                                          style: AppStyle.mainTitle,
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(
                                                  context); // Close dialog
                                            },
                                            child: Text(
                                              "Cancel",
                                              style: GoogleFonts.nunitoSans(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              deleteNoteFromFirestore(note.id);
                                              Navigator.pop(context);
                                            },
                                            child: Text("Delete",
                                                style: GoogleFonts.nunitoSans(
                                                    color: Colors.red,
                                                    fontWeight: FontWeight.bold)
                                                // TextStyle(color: Colors.red),
                                                ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => NoteEditorScreen(note: note),  // Pass the note data for editing
                                    ),
                                  );
                                },
                              ))
                          .toList(),
                    );
                  }
                  return Text(
                    "There's no note available",
                    style: GoogleFonts.nunitoSans(
                        color: Colors.white, fontSize: 18),
                  );
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NoteEditorScreen(),
              ));
        },
        label: const Text("Add Note"),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
