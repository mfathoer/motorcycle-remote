import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../../data/remote/responses/api_result.dart';
import '../../data/repository.dart';
import '../../data/remote/responses/api_response.dart';

enum EmergencyModeEvent { EMERGENCY_MODE_ON, EMERGENCY_MODE_OFF }

class EmergencyBloc extends Bloc<EmergencyModeEvent, Color> {
  final Color initialState;
  final Repository repository;

  EmergencyBloc({required this.initialState, required this.repository})
      : super(initialState);

  @override
  Stream<Color> mapEventToState(EmergencyModeEvent event) async* {
    if (event == EmergencyModeEvent.EMERGENCY_MODE_ON) {
      ApiResponse? response = await repository.turnOnEmergencyMode();
      if (response?.status == ApiResult.success) {
        yield Colors.red;
      } else {
        yield initialState;
      }
    } else {
      ApiResponse? response = await repository.turnOffEmergencyMode();
      if (response?.status == ApiResult.success) {
        yield initialState;
      } else {
        yield Colors.red;
      }
    }
  }
}
