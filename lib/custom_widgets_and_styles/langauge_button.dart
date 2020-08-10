import 'package:flutter/material.dart';

class LanguageButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const LanguageButton({
    Key key,
    this.text,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: 58,
      minWidth: 340,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 24,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      color: Color(0xFFF7CA18),
    );
  }
}
