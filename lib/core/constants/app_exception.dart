class AppException implements Exception {
  final String? errorMessage;
  const AppException(this.errorMessage);
}
