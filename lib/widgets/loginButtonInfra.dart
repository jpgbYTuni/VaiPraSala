import 'package:flutter/material.dart';

class ButtonInfra extends StatelessWidget {
  final String text;
  final double buttonWidth;
  final double buttonHeight;
  final VoidCallback onPressed;
  final Color buttonColor;

  const ButtonInfra({
    super.key,
    required this.text,
    required this.buttonWidth,
    required this.buttonHeight,
    required this.onPressed,
    required this.buttonColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        fixedSize: WidgetStatePropertyAll(Size(buttonWidth, buttonHeight)),
        backgroundColor: WidgetStatePropertyAll(buttonColor),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
