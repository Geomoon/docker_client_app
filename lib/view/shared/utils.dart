import 'package:flutter/services.dart';

Future<void> copyToClipboard(String text) async {
  return Clipboard.setData(ClipboardData(text: text));
}
