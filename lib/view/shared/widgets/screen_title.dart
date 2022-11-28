import 'package:docker_client_app/view/shared/themes/color_schemes.g.dart';
import 'package:flutter/material.dart';

class ScreenTitle extends StatelessWidget {
  const ScreenTitle(this.title, {Key? key}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(title,
        style: TextStyle(
            fontFamily: 'Epilogue',
            color: fonts['color'],
            fontSize: 30,
            fontWeight: FontWeight.bold));
  }
}
