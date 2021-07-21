import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

enum EmergencyModeEvent { EMERGENCY_MODE_ON, EMERGENCY_MODE_OFF }

class EmergencyBloc extends Bloc<EmergencyModeEvent, Color> {
  final Color initialState;
  EmergencyBloc({required this.initialState}) : super(initialState);

  @override
  Stream<Color> mapEventToState(EmergencyModeEvent event) async* {
    yield (event == EmergencyModeEvent.EMERGENCY_MODE_OFF)
        ? initialState
        : Colors.yellow;
  }
}
