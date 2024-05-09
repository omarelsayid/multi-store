import 'package:flutter/material.dart';

showSnakBar(context, String tilte) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: Colors.yellow.shade900,
    content: Text(
      tilte,
      style: const TextStyle(fontWeight: FontWeight.bold),
    ),
  ));
}
