class ApiResponse<T> {
  final num statusCode;
  final T? data;
  final String? error;

  ApiResponse({required this.statusCode, this.data, this.error});

  factory ApiResponse.standaloneLoginType({required num statusCode, String? token, String? error}) {
    return ApiResponse(
      statusCode: statusCode,
      data: token as T?,
      error: error,
    );
  }
}
