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
  final GalExceptionType type;
  final PlatformException platformException;
  final StackTrace stackTrace;

  factory GalException.fromCode({
    required String code,
    required PlatformException platformException,
    required StackTrace stackTrace,
  }) {
    final type = GalExceptionType.values.firstWhere(
      (type) => type.code == code,
      orElse: () => GalExceptionType.unexpected,
    );
    return GalException(
      type: type,
      platformException: platformException,
      stackTrace: stackTrace,
    );
  }
  @override
  String toString() => "[GalException/${type.code}]: ${type.message}";
}

enum GalExceptionType {
  /// When has no permission to access gallery app.
  /// See: https://github.com/natsuk4ze/gal/wiki/Permissions
  accessDenied,

  /// When insufficient device storage.
  notEnoughSpace,

  /// When trying to save a file in an unsupported format.
  /// See: https://github.com/natsuk4ze/gal/wiki/Formats
  notSupportedFormat,

  /// When an error occurs with unexpected.
  unexpected;

  String get code => switch (this) {
        accessDenied => 'ACCESS_DENIED',
        notEnoughSpace => 'NOT_ENOUGH_SPACE',
        notSupportedFormat => 'NOT_SUPPORTED_FORMAT',
        unexpected => 'UNEXPECTED',
      };

  String get message => switch (this) {
        accessDenied => 'You do not have permission to access the gallery app.',
        notEnoughSpace => 'Not enough space for storage.',
        notSupportedFormat => 'Unsupported file formats.',
        unexpected => 'An unexpected error has occurred.',
      };
}
