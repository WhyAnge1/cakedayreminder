class BaseError<T> {
  final T? error;
  final String message;

  BaseError({
    required this.message,
    this.error,
  });
}
