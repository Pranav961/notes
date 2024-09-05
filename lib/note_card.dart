import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notes/app_style.dart';

Widget noteCard(Function()? onTap, QueryDocumentSnapshot doc,
    Function()? onDelete, Function()? onUpdate) {
  return InkWell(
    onTap: onTap,
    child: Stack(
      alignment: Alignment.topRight,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppStyle.cardsColor[doc['color_id']]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                doc["note_title"],
                style: AppStyle.mainTitle,
              ),
              const SizedBox(height: 4),
              Text(
                doc["creation_date"],
                style: AppStyle.dateTitle,
              ),
              const SizedBox(height: 6),
              Text(
                doc["note_content"],
                overflow: TextOverflow.ellipsis,
                style: AppStyle.mainContent,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5, right: 5),
          child: PopupMenuButton(
            position: PopupMenuPosition.under,
            onSelected: (String value) {
              if (value == 'Delete') {

                onDelete?.call();
              } else if (value == 'Update') {
                onUpdate?.call();
              }
            },
            itemBuilder: (BuildContext context) {
              return {'Delete', 'Update'}.map((String choice) {
                return PopupMenuItem(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
            icon: const Icon(
              Icons.more_vert,
              color: Colors.black,
            ),
          ),
        ),
      ],
    ),
  );
}

void deleteNoteFromFirestore(String docId) {
  FirebaseFirestore.instance.collection('notes').doc(docId).delete().then((_) {
    print('Note deleted successfully');
  }).catchError((error) {
    print('Error deleting note: $error');
  });
}
