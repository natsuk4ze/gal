import 'dart:io' show ProcessException, Process;

import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;

Future<String> executeCommand(
  String value, {
  bool printResult = true,
  String? workingDirectory,
}) async {
  final executalbe = value.split(' ')[0];
  final args = value.split(' ')
    ..removeAt(0)
    ..toList();
  if (kDebugMode) {
    if (printResult) {
      print('$executalbe ${args.join(' ')}');
    }
  }
  if (kIsWeb) {
    throw UnsupportedError(
      'The command line is not supported on web',
    );
  }
  final command = await Process.run(
    executalbe,
    args,
    workingDirectory: workingDirectory,
  );
  if (command.exitCode != 0) {
    if (kDebugMode) {
      if (printResult) {
        print(
          'Process exception, ${command.stderr}',
        );
      }
    }
    throw ProcessException(
      executalbe,
      args,
      command.stderr,
      command.exitCode,
    );
  }

  return command.stdout;
}
