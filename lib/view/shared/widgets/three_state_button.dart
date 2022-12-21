import 'package:flutter/material.dart';

class ThreeStateButton extends StatefulWidget {
  const ThreeStateButton({
    super.key,
    required this.onTapState1,
    required this.onTapState2,
  });

  final Function() onTapState1;
  final Function() onTapState2;

  @override
  State<ThreeStateButton> createState() => _ThreeStateButtonState();
}

class _ThreeStateButtonState extends State<ThreeStateButton> {
  final List<Icon> _icons = const [
    Icon(Icons.filter_alt),
    Icon(Icons.keyboard_arrow_up_rounded),
    Icon(Icons.keyboard_arrow_down_rounded),
  ];

  int _state = 0;

  void _changeState() {
    switch (_state) {
      case 0:
        setState(() => _state = 1);
        widget.onTapState1();
        break;
      case 1:
        setState(() => _state = 2);
        widget.onTapState2();
        break;
      case 2:
        setState(() => _state = 0);
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
          backgroundColor: Theme.of(context).colorScheme.background,
        ),
        onPressed: _changeState,
        icon: _icons[_state],
        label: const Text('By Date'));
  }
}
