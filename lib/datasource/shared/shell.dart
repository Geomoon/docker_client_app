import 'dart:io';

class Shell {
  Future<String> run(String exec, List<String> args) async {
    try {
      var res = await Process.run(exec, args);
      return res.stdout.toString();
    } catch (e) {
      return '';
    }
  }
}
