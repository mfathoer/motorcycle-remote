import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

enum ContactEvent { CONTACT_ON, CONTACT_OFF }

class ContactBloc extends Bloc<ContactEvent, Color> {
  final Color initialState;
  ContactBloc({required this.initialState}) : super(initialState);

  @override
  Stream<Color> mapEventToState(ContactEvent event) async* {
    yield (event == ContactEvent.CONTACT_OFF) ? initialState : Colors.yellow;
  }
}
