import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Every [Exception] that [Gal] throws should be this.
@immutable
class GalException implements Exception {
  /// Creates a [GalException].
  const GalException({
    required this.type,
    required this.platformException,
    required this.stackTrace,
  });

  /// Type of error.
  ///
  /// See: [GalExceptionType]
  final GalExceptionType type;

  /// Native code error information.
  final PlatformException platformException;

  /// Stack trace of the error in dart side.
  ///
  /// The native code StackTrace is stored in [PlatformException.stacktrace].
  final StackTrace stackTrace;

  /// Creates a [GalException] whose [type] matches [PlatformException.code].
  factory GalException.fromPlatformException(
    PlatformException exception,
    StackTrace stackTrace,
  ) => GalException(
    type: GalExceptionType.values.firstWhere(
      (type) => type.code == exception.code,
      orElse: () => GalExceptionType.unexpected,
    ),
    platformException: exception,
    stackTrace: stackTrace,
  );

  /// Also shows the [PlatformException.code] and [PlatformException.message]
  /// of [platformException].
  @override
  String toString() {
    final PlatformException(:code, :message) = platformException;
    return '[GalException/${type.code}]: ${type.message} '
        '(PlatformException/$code${message == null ? '' : ': $message'})';
  }
}

/// Types of [GalException]
///
/// If the type cannot be determined, it will be [unexpected].
/// In that case, you can get support by submitting
/// an [issue](https://github.com/natsuk4ze/gal/issues)
/// including all values of [GalException.platformException]
/// and [GalException.stackTrace].
enum GalExceptionType {
  /// When the app does not have permission to access the gallery.
  /// See: [Gal.hasPermission] and [Gal.requestPermission]
  permissionDenied,

  /// When the device does not have enough storage.
  notEnoughSpace,

  /// When trying to save a file in an unsupported format.
  ///
  /// The file name must include the extension. For videos, the OS must also
  /// support the video codec. Re-encode the video if the codec is not supported.
  notSupportedFormat,

  /// When an unexpected error occurs.
  unexpected;

  /// The [PlatformException.code] that the native side throws for this type.
  String get code => switch (this) {
    permissionDenied => 'PERMISSION_DENIED',
    notEnoughSpace => 'NOT_ENOUGH_SPACE',
    notSupportedFormat => 'NOT_SUPPORTED_FORMAT',
    unexpected => 'UNEXPECTED',
  };

  /// The message that [GalException.toString] shows for this type.
  String get message => switch (this) {
    permissionDenied => 'Permission to access the gallery is denied.',
    notEnoughSpace => 'Not enough space for storage.',
    notSupportedFormat => 'Unsupported file format.',
    unexpected => 'An unexpected error has occurred.',
  };
}
