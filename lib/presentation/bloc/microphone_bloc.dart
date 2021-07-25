import 'package:flutter_bloc/flutter_bloc.dart';

enum MicrophoneEvent { LISTENING, NOT_LISTENING }

class MicrophoneBloc extends Bloc<MicrophoneEvent, bool> {
  MicrophoneBloc(bool initialState) : super(initialState);

  @override
  Stream<bool> mapEventToState(MicrophoneEvent event) async* {
    if (event == MicrophoneEvent.LISTENING) {
      yield true;
    } else {
      yield false;
    }
  }
}
