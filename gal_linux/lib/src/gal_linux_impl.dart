import 'dart:io' show Directory, File, Platform, ProcessException;

import 'package:flutter/foundation.dart' show Uint8List, immutable, kIsWeb;
import 'package:flutter/services.dart' show PlatformException;
import 'package:gal/gal.dart';
import 'package:gal_linux/src/utils/command_line.dart';
import 'package:gal_linux/src/utils/uri_extension.dart';
import 'package:path/path.dart' as path_package show basename;

enum _FileType {
  image,
  video,
}

/// Impl for Linux platform
///
/// currently the support for Linux is limitied
/// we will always use [GalExceptionType.unexpected]
///
/// it's not 100% spesefic to Linux, it could work for Unix based OS
@immutable
final class GalLinuxImpl {
  const GalLinuxImpl._();

  static bool get isLinux {
    if (kIsWeb) {
      return false;
    }
    return Platform.isLinux;
  }

  static String _baseName(String path) {
    return path_package.basename(path);
  }

  static Future<void> putVideo(String path, {String? album}) async {
    await _downloadFileToAlbum(
      path,
      fileType: _FileType.video,
      album: album,
    );
  }

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
      bool downloadedFromNetwork = false;

      // Download from network
      if (!await file.exists()) {
        final uri = Uri.parse(path);

        // If it not exists and it also doesn't starts with https
        if (!uri.isHttpBasedUrl()) {
          throw GalException(
              type: GalExceptionType.unexpected,
              platformException: PlatformException(
                code: GalExceptionType.unexpected.code,
                message:
                    'You are trying to put file with path `$path` that does not exists '
                    'locally, Also it does not start with `http` nor `https`',
                stacktrace: StackTrace.current.toString(),
              ),
              stackTrace: StackTrace.current);
        }

        // Save it to a temp directory for now
        final tempFileLocation =
            _getNewTempFileLocation(fileName: _baseName(path));
        await executeCommand('wget -O $tempFileLocation $path');
        downloadedFromNetwork = true;
        path = tempFileLocation;
      }

      // Save it to the album
      if (album != null) {
        final newFileLocation = _getNewFileLocationWithAlbum(
          fileType: fileType,
          album: album,
          fileName: _baseName(path),
        );
        await _makeSureParentFolderExists(path: newFileLocation);
        await executeCommand(
          'mv $path $newFileLocation',
        );
      } else {
        // Save it in temp directory
        final newFileLocation =
            _getNewTempFileLocation(fileName: _baseName(path));
        await _makeSureParentFolderExists(path: newFileLocation);
        await executeCommand('mv $path $newFileLocation');
      }
      // Remove the downloaded file from the network if it exists
      if (downloadedFromNetwork) {
        await executeCommand(
          'rm $path',
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

  static String _getHomeDirectory() =>
      Platform.environment['HOME'] ??
      (throw UnsupportedError(
          'The HOME environment variable is null and it is required'));

  static String _getNewFileLocationWithAlbum({
    required _FileType fileType,
    required String album,
    required String fileName,
  }) {
    final currentDate = DateTime.now().toIso8601String();
    final newFileLocation = switch (fileType) {
      _FileType.image =>
        '${_getHomeDirectory()}/Pictures/$album/$currentDate-$fileName',
      _FileType.video =>
        '${_getHomeDirectory()}/Videos/$album/$currentDate-$fileName',
    };
    return newFileLocation;
  }

  static String _getNewTempFileLocation({
    required String fileName,
  }) {
    final currentDate = DateTime.now().toIso8601String();
    return '${Directory.systemTemp.path}/gal/$currentDate-$fileName';
  }

  static Future<void> _makeSureParentFolderExists(
      {required String path}) async {
    await executeCommand('mkdir -p ${File(path).parent.path}');
  }

  static Future<void> putImageBytes(Uint8List bytes, {String? album}) async {
    try {
      final fileName = '${DateTime.now().toIso8601String()}.png';
      final newFileLocation = album == null
          ? _getNewTempFileLocation(fileName: DateTime.now().toIso8601String())
          : _getNewFileLocationWithAlbum(
              fileType: _FileType.image,
              album: album,
              fileName: fileName,
            );
      final file = File(newFileLocation);
      await file.writeAsBytes(bytes);
    } catch (e) {
      throw GalException(
        type: GalExceptionType.unexpected,
        platformException: PlatformException(
          code: e.toString(),
          details: e.toString(),
          message: e.toString(),
          stacktrace: StackTrace.current.toString(),
        ),
        stackTrace: StackTrace.current,
      );
    }
  }

  static Future<void> open() async =>
      executeCommand('xdg-open ${_getHomeDirectory()}/Pictures');

  /// Requesting an access usually automated if there is a sandbox
  /// but we don't have much info and usually we have an access
  static Future<bool> hasAccess({bool toAlbum = false}) async => true;

  /// Requesting an access usually automated once we try
  /// to save an image if there was a sandbox
  /// but we don't have much info and usually we have an access
  static Future<bool> requestAccess({bool toAlbum = false}) async => true;
}
