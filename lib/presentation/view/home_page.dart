import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../util/speech_recognizer.dart';
import '../../util/speech_command.dart';
import '../bloc/starter_bloc.dart';
import '../bloc/contact_bloc.dart';
import '../bloc/emergency_bloc.dart';
import '../bloc/microphone_bloc.dart';

class HomePage extends StatelessWidget {
  String text = "";
  @override
  Widget build(BuildContext context) {
    StarterBloc _starterBloc = BlocProvider.of<StarterBloc>(context);
    ContactBloc _contactBloc = BlocProvider.of<ContactBloc>(context);
    EmergencyBloc _emergencyBloc = BlocProvider.of<EmergencyBloc>(context);
    MicrophoneBloc _microphoneBloc = BlocProvider.of<MicrophoneBloc>(context);

    return Scaffold(
      body: Column(
        children: [
          Flexible(
              child: Center(
            child: BlocBuilder<StarterBloc, Color>(
                builder: (context, engineStateColor) => ElevatedButton(
                    onPressed: () {
                      if (engineStateColor == Colors.green) {
                        _starterBloc.add(StarterEvent.ENGINE_ON);
                        _contactBloc.add(ContactEvent.CONTACT_ON);
                      } else {
                        _starterBloc.add(StarterEvent.ENGINE_OFF);
                        _contactBloc.add(ContactEvent.CONTACT_OFF);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        shape: CircleBorder(), primary: engineStateColor),
                    child: Container(
                      width: 200,
                      height: 200,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(shape: BoxShape.circle),
                      child: Text(
                        (engineStateColor == Colors.green)
                            ? "START\nENGINE"
                            : "STOP\nENGINE",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 24),
                      ),
                    ))),
          )),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BlocBuilder<ContactBloc, Color>(
                builder: (context, contactStateColor) => ElevatedButton(
                    onPressed: () {
                      if (contactStateColor == Theme.of(context).primaryColor) {
                        _contactBloc.add(ContactEvent.CONTACT_ON);
                      } else {
                        _contactBloc.add(ContactEvent.CONTACT_OFF);
                        _starterBloc.add(StarterEvent.ENGINE_OFF);
                      }
                    },
                    style: ElevatedButton.styleFrom(primary: contactStateColor),
                    child: Container(
                        width: 128,
                        height: 40,
                        alignment: Alignment.center,
                        child: Text((contactStateColor ==
                                Theme.of(context).primaryColor)
                            ? "PRE-START"
                            : "SHUT DOWN"))),
              ),
              SizedBox(
                width: 24,
              ),
              BlocBuilder<EmergencyBloc, Color>(
                builder: (context, emergencyStateColor) => ElevatedButton(
                    onPressed: () {
                      if (emergencyStateColor ==
                          Theme.of(context).primaryColor) {
                        _emergencyBloc
                            .add(EmergencyModeEvent.EMERGENCY_MODE_ON);
                      } else {
                        _emergencyBloc
                            .add(EmergencyModeEvent.EMERGENCY_MODE_OFF);
                      }
                    },
                    style:
                        ElevatedButton.styleFrom(primary: emergencyStateColor),
                    child: Container(
                        width: 128,
                        height: 40,
                        alignment: Alignment.center,
                        child: Text((emergencyStateColor ==
                                Theme.of(context).primaryColor)
                            ? "EMERGENCY MODE"
                            : "TURN OFF"))),
              )
            ],
          ),
          SizedBox(
            height: 175,
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: BlocBuilder<MicrophoneBloc, bool>(
        builder: (context, isListening) => AvatarGlow(
          animate: isListening,
          endRadius: 50,
          glowColor: Theme.of(context).primaryColor,
          child: FloatingActionButton(
              child: Icon((isListening) ? Icons.mic : Icons.mic_none),
              onPressed: () => SpeechRecognizer.toggleRecording(
                  onResult: (text) => this.text = text,
                  onListening: (isListening) {
                    if (isListening) {
                      _microphoneBloc.add(MicrophoneEvent.LISTENING);
                    } else {
                      _microphoneBloc.add(MicrophoneEvent.NOT_LISTENING);
                      Future.delayed(Duration(seconds: 1), () {
                        //extract voice command
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text(text)));
                        SpeechCommand.extractText(
                          rawText: text,
                          onResult: (commandCode) {
                            switch (commandCode) {
                              case SpeechCommand.turnOnEngineCode:
                                {
                                  _starterBloc.add(StarterEvent.ENGINE_ON);
                                  _contactBloc.add(ContactEvent.CONTACT_ON);
                                }
                                break;
                              case SpeechCommand.turnOffEngineCode:
                                {
                                  _starterBloc.add(StarterEvent.ENGINE_OFF);
                                  _contactBloc.add(ContactEvent.CONTACT_OFF);
                                }

                                break;
                              case SpeechCommand.turnOnContactCode:
                                _contactBloc.add(ContactEvent.CONTACT_ON);
                                break;
                              case SpeechCommand.turnOffContactCode:
                                {
                                  _contactBloc.add(ContactEvent.CONTACT_ON);
                                  _starterBloc.add(StarterEvent.ENGINE_OFF);
                                }
                                break;
                              case SpeechCommand.turnOnEmergencyCode:
                                _emergencyBloc
                                    .add(EmergencyModeEvent.EMERGENCY_MODE_ON);
                                break;
                              case SpeechCommand.turnOffEmergencyCode:
                                _emergencyBloc
                                    .add(EmergencyModeEvent.EMERGENCY_MODE_OFF);
                                break;
                            }
                          },
                        );
                      });
                    }
                  })),
        ),
      ),
    );
  }
}
