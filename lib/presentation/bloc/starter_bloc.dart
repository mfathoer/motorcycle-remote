import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

enum StarterEvent { ENGINE_ON, ENGINE_OFF }

class StarterBloc extends Bloc<StarterEvent, Color> {
  StarterBloc() : super(Colors.green);

  @override
  Stream<Color> mapEventToState(StarterEvent event) async* {
    yield (event == StarterEvent.ENGINE_ON) ? Colors.red : Colors.green;
  }
}
