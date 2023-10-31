import 'dart:io' show Directory, File, Platform, ProcessException;

import 'package:flutter/foundation.dart' show Uint8List, immutable, kIsWeb;
import 'package:flutter/services.dart' show PlatformException;
import 'package:gal/src/gal_exception.dart';
import 'package:gal/src/utils/command_line.dart';
import 'package:gal/src/utils/extensions/uri.dart';
import 'package:meta/meta.dart' show experimental;
import 'package:path/path.dart' show basename;

enum _FileType {
  image,
  video,
}

/// Impl for Linux platform
///
/// currently the support for Linux is limitied
/// we will always use [GalExceptionType.unexpected]
///
/// it's 100% spesefic to Linux, it could work for Unix based OS
@immutable
@experimental
final class GalLinuxImpl {
  const GalLinuxImpl._();

  static bool get isLinux {
    if (kIsWeb) {
      return false;
    }
    return Platform.isMacOS;
  }

  /// Save a video to the gallery from file [path].
  ///
  /// Specify the album with [album]. If it does not exist, it will be created.
  /// [path] must include the file extension.
  /// ```dart
  /// await Gal.putVideo('${Directory.systemTemp.path}/video.mp4');
  /// ```
  /// Throws an [GalException] If you do not have access premission or
  /// if an error occurs during saving.
  /// See: [Formats](https://github.com/natsuk4ze/gal/wiki/Formats)
  static Future<void> putVideo(String path, {String? album}) async {
    await _downloadFileToAlbum(
      path,
      fileType: _FileType.video,
      album: album,
    );
  }

  /// Save a image to the gallery from file [path].
  ///
  /// Specify the album with [album]. If it does not exist, it will be created.
  /// [path] must include the file extension.
  /// ```dart
  /// await Gal.putImage('${Directory.systemTemp.path}/image.jpg');
  /// ```
  /// Throws an [GalException] If you do not have access premission or
  /// if an error occurs during saving.
  /// See: [Formats](https://github.com/natsuk4ze/gal/wiki/Formats)
  static Future<void> putImage(String path, {String? album}) async {
    await _downloadFileToAlbum(
      path,
      fileType: _FileType.image,
      album: album,
    );
  }

  static Future<void> _downloadFileToAlbum(
    String path, {
    required _FileType fileType,
    String? album,
  }) async {
    try {
      final file = File(path);
      final fileExists = await file.exists();
      var filePath = path;

      String? downloadedFilePath;
      if (!fileExists) {
        final fileName = basename(path);
        final uri = Uri.parse(path);
        if (!uri.isHttpBasedUrl()) {
          throw UnsupportedError(
            'You are trying to put file with path `$path` that does not exists '
            'locally, Also it does not start with `http` or `https`',
          );
        }
        await executeCommand(
          executalbe: 'wget',
          args: [
            '-O',
            fileName,
            path,
          ],
        );
        final workingDir = Directory.current.path;
        downloadedFilePath = '$workingDir/$fileName';
        filePath = downloadedFilePath;
      }
      final fileName = basename(filePath);
      if (album != null) {
        final newFileLocation = _getNewFileLocationWithAlbum(
          fileType: fileType,
          album: album,
          fileName: fileName,
        );
        await executeCommand(
          executalbe: 'mkdir',
          args: [
            '-p',
            newFileLocation,
          ],
        );
        await executeCommand(
          executalbe: 'cp',
          args: [
            filePath,
            newFileLocation,
          ],
        );
      } else {
        final newLocation = _getNewFileLocation(fileName: fileName);
        await executeCommand(
          executalbe: 'mkdir',
          args: [
            '-p',
            newLocation,
          ],
        );
        await executeCommand(
          executalbe: 'cp',
          args: [
            filePath,
            newLocation,
          ],
        );
      }
      // Remove the downloaded file from the network if it exists
      if (downloadedFilePath != null) {
        await executeCommand(
          executalbe: 'rm',
          args: [
            downloadedFilePath,
          ],
        );
      }
    } on ProcessException catch (e) {
      throw GalException(
        type: GalExceptionType.unexpected,
        platformException: PlatformException(
          code: e.errorCode.toString(),
          message: e.toString(),
          details: e.message.toString(),
          stacktrace: StackTrace.current.toString(),
        ),
        stackTrace: StackTrace.current,
      );
    } catch (e) {
      throw GalException(
        type: GalExceptionType.unexpected,
        platformException: PlatformException(
          code: e.toString(),
          message: e.toString(),
          details: e.toString(),
          stacktrace: StackTrace.current.toString(),
        ),
        stackTrace: StackTrace.current,
      );
    }
  }

  static String _getNewFileLocationWithAlbum({
    required _FileType fileType,
    required String album,
    required String fileName,
  }) {
    final newFileLocation = switch (fileType) {
      _FileType.image => '~/Pictures/$album/$fileName',
      _FileType.video => '~/Videos/$album/$fileName',
    };
    return newFileLocation;
  }

  static String _getNewFileLocation({
    required String fileName,
  }) {
    return '${Directory.systemTemp.path}/$fileName';
  }

  /// Save a image to the gallery from [Uint8List].
  ///
  /// Specify the album with [album]. If it does not exist, it will be created.
  /// Throws an [GalException] If you do not have access premission or
  /// if an error occurs during saving.
  /// See: [Formats](https://github.com/natsuk4ze/gal/wiki/Formats)
  static Future<void> putImageBytes(Uint8List bytes, {String? album}) async {
    final fileName = '${DateTime.now().toIso8601String()}.png';
    final newFileLocation = album == null
        ? _getNewFileLocation(fileName: DateTime.now().toIso8601String())
        : _getNewFileLocationWithAlbum(
            fileType: _FileType.image,
            album: album,
            fileName: fileName,
          );
    final file = File(newFileLocation);
    await file.writeAsBytes(bytes);
  }

  /// Open gallery app.
  ///
  /// If there are multiple gallery apps, App selection sheet may be displayed.
  static Future<void> open() async => throw UnsupportedError(
        'Linux is not supported yet.',
      );

  /// Check if the app has access permissions.
  ///
  /// Use the [toAlbum] for additional permissions to save to an album.
  /// If you want to save to an album other than the one created by your app
  /// See: [Permissions](https://github.com/natsuk4ze/gal/wiki/Permissions)
  static Future<bool> hasAccess({bool toAlbum = false}) async => true;

  /// Request access permissions.
  ///
  /// Returns [true] if access is granted, [false] if denied.
  /// If access was already granted, the dialog is not displayed and returns true.
  /// Use the [toAlbum] for additional permissions to save to an album.
  /// If you want to save to an album other than the one created by your app
  /// See: [Permissions](https://github.com/natsuk4ze/gal/wiki/Permissions)
  static Future<bool> requestAccess({bool toAlbum = false}) async => true;
}
