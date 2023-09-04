import 'package:flutter/foundation.dart';

/// Every [Exception] that [Gal] throws should be this.
@immutable
class GalException implements Exception {
  const GalException({
    required this.type,
    required this.error,
    required this.stackTrace,
  });
  final GalExceptionType type;
  final Object? error;
  final StackTrace stackTrace;

  factory GalException.fromCode({
    required String code,
    required Object? error,
    required StackTrace stackTrace,
  }) {
    final type = GalExceptionType.values.firstWhere(
      (type) => type.code == code,
      orElse: () => GalExceptionType.unexpected,
    );
    return GalException(type: type, error: error, stackTrace: stackTrace);
  }
  @override
  String toString() => "[GalException/${type.code}]: ${type.message}";
}

enum GalExceptionType {
  /// When has no permission to access gallery app.
  accessDenied,

  /// When insufficient device storage.
  notEnoughSpace,

  /// When trying to save a file in an unsupported format.
  /// See: https://github.com/natsuk4ze/gal/wiki/Formats
  notSupportedFormat,

  /// When an error occurs with unexpected.
  unexpected,

  @Deprecated(
      'Use [unexpected] instead. https://github.com/natsuk4ze/gal/pull/25')
  notHandle;

  String get code => switch (this) {
        accessDenied => 'ACCESS_DENIED',
        notEnoughSpace => 'NOT_ENOUGH_SPACE',
        notSupportedFormat => 'NOT_SUPPORTED_FORMAT',
        unexpected => 'UNEXPECTED',
        _ => 'NOT_HANDLE',
      };

  String get message => switch (this) {
        accessDenied => 'You do not have permission to access the gallery app.',
        notEnoughSpace => 'Not enough space for storage.',
        notSupportedFormat => 'Unsupported file formats.',
        unexpected => 'An unexpected error has occurred.',
        _ => 'An unexpected error has occurred.',
      };
}
