import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/starter_bloc.dart';
import '../bloc/contact_bloc.dart';
import '../bloc/emergency_bloc.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    StarterBloc _starterBloc = BlocProvider.of<StarterBloc>(context);
    ContactBloc _contactBloc = BlocProvider.of<ContactBloc>(context);
    EmergencyBloc _emergencyBloc = BlocProvider.of<EmergencyBloc>(context);

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
                        "START\nENGINE",
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
                      if (contactStateColor == Colors.blue) {
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
                        child: Text("PRE-START"))),
              ),
              SizedBox(
                width: 24,
              ),
              BlocBuilder<EmergencyBloc, Color>(
                builder: (context, emergencyStateColor) => ElevatedButton(
                    onPressed: () {
                      if (emergencyStateColor == Colors.blue) {
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
                        child: Text("EMERGENCY MODE"))),
              )
            ],
          ),
          SizedBox(
            height: 48,
          ),
          FloatingActionButton(child: Icon(Icons.mic), onPressed: () {}),
          SizedBox(
            height: 56,
          ),
        ],
      ),
    );
  }
}
