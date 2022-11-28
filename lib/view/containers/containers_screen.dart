import 'package:flutter/material.dart';

class ContainersScreen extends StatelessWidget {
  const ContainersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 1,
            child: Container(
              color: Colors.red,
            )),
        Expanded(
            flex: 4,
            child: Container(
              color: Colors.amber,
            ))
      ],
    );
  }
}
