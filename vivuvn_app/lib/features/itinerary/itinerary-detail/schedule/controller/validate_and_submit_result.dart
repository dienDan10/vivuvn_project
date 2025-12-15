enum ValidateAndSubmitStatus {
  advance,
  validationError,
  submittedSuccess,
  submittedError,
}

class ValidateAndSubmitResult {
  final ValidateAndSubmitStatus status;
  final String? message;
  final List<String> warnings;
  final int? itineraryId;

  const ValidateAndSubmitResult._(
    this.status,
    this.message, [
    this.warnings = const [],
    this.itineraryId,
  ]);

  factory ValidateAndSubmitResult.advance() =>
      const ValidateAndSubmitResult._(ValidateAndSubmitStatus.advance, null);
  factory ValidateAndSubmitResult.validationError(final String msg) =>
      ValidateAndSubmitResult._(ValidateAndSubmitStatus.validationError, msg);
  factory ValidateAndSubmitResult.submittedSuccess([
    final List<String> warnings = const [],
    final int? itineraryId,
  ]) =>
      ValidateAndSubmitResult._(
        ValidateAndSubmitStatus.submittedSuccess,
        null,
        warnings,
        itineraryId,
      );
  factory ValidateAndSubmitResult.submittedError(final String msg) =>
      ValidateAndSubmitResult._(ValidateAndSubmitStatus.submittedError, msg);
}
