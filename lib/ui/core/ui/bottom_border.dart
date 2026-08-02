import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
BoxDecoration BottomBorder(Color borderColor) {
  return BoxDecoration(
    border: Border(
      bottom: BorderSide(
        width: 1,
        color: borderColor
      )
    )
  );
}