import 'package:flutter/material.dart';

const String sBaseUrl = 'https://api.github.com/graphql';

var appBarTheme = AppBarTheme(
  color: Colors.pink.shade300,
  titleTextStyle: const TextStyle(
    color: Colors.white,
    fontSize: 18,
  ),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
      bottomLeft: Radius.circular(25),
      bottomRight: Radius.circular(25),
    ),
  ),
);
