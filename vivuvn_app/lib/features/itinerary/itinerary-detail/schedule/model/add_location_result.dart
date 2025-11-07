class AddLocationResult {
  final bool isSuccess;
  final String message;

  const AddLocationResult({required this.isSuccess, required this.message});

  factory AddLocationResult.success(final String message) =>
      AddLocationResult(isSuccess: true, message: message);

  factory AddLocationResult.failure(final String message) =>
      AddLocationResult(isSuccess: false, message: message);
}

