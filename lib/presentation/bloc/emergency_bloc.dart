import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:motorcycle_remote/data/responses/api_result.dart';
import '../../data/api_service.dart';
import '../../data/responses/api_response.dart';

enum EmergencyModeEvent { EMERGENCY_MODE_ON, EMERGENCY_MODE_OFF }

class EmergencyBloc extends Bloc<EmergencyModeEvent, Color> {
  final Color initialState;
  final ApiService apiService;

  EmergencyBloc({required this.initialState, required this.apiService})
      : super(initialState);

  @override
  Stream<Color> mapEventToState(EmergencyModeEvent event) async* {
    if (event == EmergencyModeEvent.EMERGENCY_MODE_ON) {
      ApiResponse? response = await apiService.turnOnEmergencyMode();
      if (response?.status == ApiResult.success) {
        yield Colors.red;
      } else {
        yield initialState;
      }
    } else {
      ApiResponse? response = await apiService.turnOffEmergencyMode();
      if (response?.status == ApiResult.success) {
        yield initialState;
      } else {
        yield Colors.red;
      }
    }
  }
}
