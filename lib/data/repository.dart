import '../data/remote/api_service.dart';
import 'remote/responses/api_response.dart';

class Repository {
  final ApiService apiService;

  Repository({required this.apiService});

  Future<ApiResponse?> turnOnEngine() {
    return apiService.turnOnEngine();
  }

  Future<ApiResponse?> turnOffEngine() {
    return apiService.turnOffEngine();
  }

  Future<ApiResponse?> turnOffContact() {
    return apiService.turnOffContact();
  }

  Future<ApiResponse?> turnOnContact() {
    return apiService.turnOnContact();
  }

  Future<ApiResponse?> turnOnEmergencyMode() {
    return apiService.turnOnEmergencyMode();
  }

  Future<ApiResponse?> turnOffEmergencyMode() {
    return apiService.turnOffEmergencyMode();
  }
}
