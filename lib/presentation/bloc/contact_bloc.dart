import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../../data/remote/responses/api_result.dart';
import '../../data/repository.dart';
import '../../data/remote/responses/api_response.dart';

enum ContactEvent { CONTACT_ON, CONTACT_OFF }

class ContactBloc extends Bloc<ContactEvent, Color> {
  final Color initialState;
  final Repository repository;

  ContactBloc({required this.initialState, required this.repository})
      : super(initialState);

  @override
  Stream<Color> mapEventToState(ContactEvent event) async* {
    if (event == ContactEvent.CONTACT_ON) {
      ApiResponse? response = await repository.turnOnContact();
      if (response?.status == ApiResult.success) {
        yield Colors.red;
      } else {
        yield initialState;
      }
    } else {
      ApiResponse? response = await repository.turnOffContact();
      if (response?.status == ApiResult.success) {
        yield initialState;
      } else {
        yield Colors.red;
      }
    }
  }
}
