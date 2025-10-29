enum ValidateAndSubmitStatus {
  advance,
  validationError,
  submittedSuccess,
  submittedError,
}

class ValidateAndSubmitResult {
  final ValidateAndSubmitStatus status;
  final String? message;

  const ValidateAndSubmitResult._(this.status, this.message);

  factory ValidateAndSubmitResult.advance() =>
      const ValidateAndSubmitResult._(ValidateAndSubmitStatus.advance, null);
  factory ValidateAndSubmitResult.validationError(final String msg) =>
      ValidateAndSubmitResult._(ValidateAndSubmitStatus.validationError, msg);
  factory ValidateAndSubmitResult.submittedSuccess() =>
      const ValidateAndSubmitResult._(
        ValidateAndSubmitStatus.submittedSuccess,
        null,
      );
  factory ValidateAndSubmitResult.submittedError(final String msg) =>
      ValidateAndSubmitResult._(ValidateAndSubmitStatus.submittedError, msg);
}
