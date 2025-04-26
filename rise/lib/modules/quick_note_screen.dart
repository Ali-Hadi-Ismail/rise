import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:rise/models/note.dart';

class QuickNotesWidget extends StatelessWidget {
  QuickNotesWidget({Key? key}) : super(key: key);

  List<Note> notes = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color(0xFFf96060),
          title: const Text(
            'Quick Notes (coming soon)',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          centerTitle: true,
        ),
        body: (notes.length != 0)
            ? ListView.builder(
                itemCount: notes.length,
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  return _buildNoteCard(
                    notes[index].data,
                  );
                })
            : Center(
                child: Lottie.asset(
                  "assets/lottie/noData.json",
                  width: 400,
                  height: 500,
                  fit: BoxFit.fitWidth,
                  repeat: true,
                  reverse: true,
                  animate: true,
                ),
              ));
  }

  Widget _buildNoteCard(String content) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 3,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              content,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
