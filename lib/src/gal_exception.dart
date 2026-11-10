import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Every [Exception] that [Gal] throws should be this.
@immutable
class GalException implements Exception {
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

  @override
  String toString() => "[GalException/${type.code}]: ${type.message}";
}

/// Types of [GalException]
///
/// If the type cannot be determined, it will be [unexpected].
/// In that case, you can get support by submitting
/// an [issue](https://github.com/natsuk4ze/gal/issues)
/// including all values of [GalException.platformException]
/// and [GalException.stackTrace].
enum GalExceptionType {
  /// When has no permission to access gallery app.
  /// See: [Gal.hasPermission] and [Gal.requestPermission]
  permissionDenied,

  /// When insufficient device storage.
  notEnoughSpace,

  /// When trying to save a file in an unsupported format.
  ///
  /// The file name must include the extension. For videos, the OS must also
  /// support the video codec. Re-encode the video if the codec is not supported.
  notSupportedFormat,

  /// When an error occurs with unexpected.
  unexpected;

  String get code => switch (this) {
    permissionDenied => 'PERMISSION_DENIED',
    notEnoughSpace => 'NOT_ENOUGH_SPACE',
    notSupportedFormat => 'NOT_SUPPORTED_FORMAT',
    unexpected => 'UNEXPECTED',
  };

  String get message => switch (this) {
    permissionDenied => 'Permission to access the gallery is denied.',
    notEnoughSpace => 'Not enough space for storage.',
    notSupportedFormat => 'Unsupported file formats.',
    unexpected => 'An unexpected error has occurred.',
  };
}
