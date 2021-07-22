import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:motorcycle_remote/data/responses/api_result.dart';
import '../../data/api_service.dart';
import '../../data/responses/api_response.dart';

enum StarterEvent { ENGINE_ON, ENGINE_OFF }

class StarterBloc extends Bloc<StarterEvent, Color> {
  final ApiService apiService;

  StarterBloc({required this.apiService}) : super(Colors.green);

  @override
  Stream<Color> mapEventToState(StarterEvent event) async* {
    if (event == StarterEvent.ENGINE_OFF) {
      ApiResponse response = await apiService.turnOffEngine();
      if (response.status == ApiResult.succeed) {
        yield Colors.green;
      } else {
        yield Colors.red;
      }
    } else {
      ApiResponse response = await apiService.turnOnEngine();
      if (response.status == ApiResult.succeed) {
        yield Colors.red;
      } else {
        yield Colors.green;
      }
    }
  }
}
