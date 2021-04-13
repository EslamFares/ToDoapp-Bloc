import 'package:flutter/material.dart';

Widget noTasksYet() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Icon(
        Icons.note_add,
        size: 100,
        color: Colors.teal,
      ),
      Text(
        'No Tasks yet...',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
      ),
      Text(
        'please, add new Tasks',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
    ],
  );
}
