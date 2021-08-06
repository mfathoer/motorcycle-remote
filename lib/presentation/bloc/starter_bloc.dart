import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../../data/remote/responses/api_result.dart';
import '../../data/repository.dart';
import '../../data/remote/responses/api_response.dart';

enum StarterEvent { ENGINE_ON, ENGINE_OFF }

class StarterBloc extends Bloc<StarterEvent, Color> {
  final Repository repository;
  StarterBloc({required this.repository}) : super(Colors.green);

  @override
  Stream<Color> mapEventToState(StarterEvent event) async* {
    if (event == StarterEvent.ENGINE_OFF) {
      ApiResponse? response = await repository.turnOffEngine();
      if (response?.status == ApiResult.success) {
        yield Colors.green;
      } else {
        yield Colors.red;
      }
    } else {
      ApiResponse? response = await repository.turnOnEngine();
      if (response?.status == ApiResult.success) {
        yield Colors.red;
      } else {
        yield Colors.green;
      }
    }
  }
}
