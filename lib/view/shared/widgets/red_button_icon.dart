import 'package:flutter/material.dart';

class RedButtonIcon extends StatelessWidget {
  const RedButtonIcon({Key? key, required this.onPressed}) : super(key: key);

  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            backgroundColor:
                Theme.of(context).colorScheme.onError.withOpacity(0.08)),
        icon: Icon(Icons.delete_forever_rounded,
            color: Theme.of(context).colorScheme.errorContainer),
        label: Text('Delete',
            style: TextStyle(
                color: Theme.of(context).colorScheme.errorContainer)));
  }
}
