import 'dart:io' show ProcessException, Process;

import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;

Future<String> executeCommand({
  required String executalbe,
  List<String> args = const [],
  bool printResult = true,
}) async {
  if (kDebugMode) {
    if (printResult) {
      print('\n command: $executalbe ${args.join(' ')}');
    }
  }
  if (kIsWeb) {
    throw UnsupportedError(
      'The command line is not supported on web',
    );
  }
  final command = await Process.run(executalbe, args);
  if (command.exitCode != 0) {
    print(
      'Process exception, ${command.stderr}',
    );
    throw ProcessException(
      executalbe,
      args,
      command.stderr,
      command.exitCode,
    );
  }

  return command.stdout;
}
