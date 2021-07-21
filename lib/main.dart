import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motorcycle_remote/main_bloc_observer.dart';

import 'presentation/bloc/contact_bloc.dart';
import 'presentation/bloc/emergency_bloc.dart';
import 'presentation/bloc/starter_bloc.dart';
import 'presentation/view/home_page.dart';

void main() {
  Bloc.observer = MainBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
            create: (BuildContext context) =>
                ContactBloc(initialState: primaryColor)),
        BlocProvider<StarterBloc>(
            create: (BuildContext context) => StarterBloc()),
        BlocProvider<EmergencyBloc>(
            create: (BuildContext context) =>
                EmergencyBloc(initialState: primaryColor))
      ], child: HomePage()),
    );
  }
}
