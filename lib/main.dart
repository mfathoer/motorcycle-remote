import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motorcycle_remote/injector.dart';

import 'presentation/bloc/microphone_bloc.dart';
import 'main_bloc_observer.dart';
import 'presentation/bloc/contact_bloc.dart';
import 'presentation/bloc/emergency_bloc.dart';
import 'presentation/bloc/starter_bloc.dart';
import 'presentation/view/home_page.dart';
import '../../data/repository.dart';

void main() {
  setupDependencies();
  Bloc.observer = MainBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Repository _repository = getIt<Repository>();

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;
    return MaterialApp(
      title: 'Motorcycle Remote',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MultiBlocProvider(providers: [
        BlocProvider<ContactBloc>(
            create: (BuildContext context) => ContactBloc(
                initialState: primaryColor, repository: _repository)),
        BlocProvider<StarterBloc>(
            create: (BuildContext context) =>
                StarterBloc(repository: _repository)),
        BlocProvider<EmergencyBloc>(
            create: (BuildContext context) => EmergencyBloc(
                initialState: primaryColor, repository: _repository)),
        BlocProvider(create: (BuildContext context) => MicrophoneBloc(false)),
      ], child: HomePage()),
    );
  }
}
