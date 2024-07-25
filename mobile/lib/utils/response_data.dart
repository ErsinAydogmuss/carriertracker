class ResponseData<T> {
  final bool success;
  final String? message;
  final T? data;

  ResponseData({
    required this.success,
    this.message,
    this.data,
  });
}