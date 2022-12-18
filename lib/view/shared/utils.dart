import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

Future<void> copyToClipboard(String text) async {
  return Clipboard.setData(ClipboardData(text: text));
}

String formatDate(DateTime date) =>
    DateFormat('yyyy-MM-dd – kk:mm').format(date);
