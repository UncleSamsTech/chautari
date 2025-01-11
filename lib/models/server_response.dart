class ServerResponse {
  final String message;
  final int status;
  final String statusText;
  final dynamic data;
  final Map<String, List<String>>? headers;

  ServerResponse({
    required this.message,
    required this.status,
    required this.statusText,
    this.data,
    this.headers,
  });

  factory ServerResponse.fromJson(Map<String, dynamic> json,
      {Map<String, List<String>>? headers}) {
    return ServerResponse(
      message: json['message'],
      status: json['status'],
      statusText: json['statusText'],
      data: json['data'] ?? null,
      headers: headers,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'status': status,
      'statusText': statusText,
      'data': data ?? null,
    };
  }
}
