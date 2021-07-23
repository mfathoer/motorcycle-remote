import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../../data/responses/api_result.dart';
import '../../data/api_service.dart';
import '../../data/responses/api_response.dart';

enum ContactEvent { CONTACT_ON, CONTACT_OFF }

class ContactBloc extends Bloc<ContactEvent, Color> {
  final Color initialState;
  final ApiService apiService;

  ContactBloc({required this.initialState, required this.apiService})
      : super(initialState);

  @override
  Stream<Color> mapEventToState(ContactEvent event) async* {
    if (event == ContactEvent.CONTACT_ON) {
      ApiResponse? response = await apiService.turnOnContact();
      if (response?.status == ApiResult.success) {
        yield Colors.red;
      } else {
        yield initialState;
      }
    } else {
      ApiResponse? response = await apiService.turnOffContact();
      if (response?.status == ApiResult.success) {
        yield initialState;
      } else {
        yield Colors.red;
      }
    }
  }
}
