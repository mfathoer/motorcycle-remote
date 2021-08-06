import 'package:equatable/equatable.dart';

class ApiResponse extends Equatable {
  final String status;
  final String message;

  const ApiResponse({required this.status, required this.message});

  @override
  List<Object?> get props => [status, message];

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
        status: json["status"] as String, message: json["message"] as String);
  }
}
