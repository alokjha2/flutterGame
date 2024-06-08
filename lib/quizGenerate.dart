import 'dart:convert';
import 'dart:io';

Future<String> runPythonScript(
) async {
  try {
      print("done1");
    final process = await Process.start(
      'python',
      
      ["main.py"],
      runInShell: true,
    );

      print("done2");
    final output = await process.stdout.transform(utf8.decoder).join();
    final errorOutput = await process.stderr.transform(utf8.decoder).join();

    print(process.exitCode);

    if (await process.exitCode == 0) {
      print("done3");
      return output.trim();
    } else {
      return 'Error: $errorOutput';
    }
  } catch (e) {
    return 'Error: $e';
  }
}