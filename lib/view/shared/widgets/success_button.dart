import 'package:flutter/material.dart';

class SuccessButton extends StatelessWidget {
  const SuccessButton({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
        decoration: BoxDecoration(
            color: const Color(0xFF39D353).withOpacity(0.1),
            borderRadius: BorderRadius.circular(24.0)),
        child: Row(
          children: [
            const Icon(Icons.done_rounded, color: Color(0xFF39D353)),
            const SizedBox(width: 6.0),
            Text(text, style: const TextStyle(color: Color(0xFF39D353))),
          ],
        ));
  }
}
