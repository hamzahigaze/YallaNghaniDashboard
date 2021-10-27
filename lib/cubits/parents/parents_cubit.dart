import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:yalla_dashboard/forms/parents/messages/create_message_form.dart';
import 'package:yalla_dashboard/helpers/const_data_helper.dart';
import 'package:yalla_dashboard/models/parents/message.dart';
import 'package:yalla_dashboard/models/parents/parent.dart';
import 'package:yalla_dashboard/providers/parents_provider.dart';
import 'package:yalla_dashboard/services/api_connection/api_connection_service.dart';

part 'parents_state.dart';

class ParentsCubit extends Cubit<ParentsState> {
  ParentsCubit(this.parentsProvider) : super(ParentsCubitInitial());

  ParentsProvider parentsProvider;
  String get apiPath => '${ConstDataHelper.baseUrl}/parents';

  Future<void> fetchParents() async {
    emit(ParentsCubitLoadInProgress());

    var result = await ApiCaller.request(
      url: '$apiPath',
      method: HttpMethod.GET,
      headers: ConstDataHelper.apiCommonHeaders,
    );
    if (result is Ok) {
      List<dynamic> items = jsonDecode(result.body)['outcome']['items'];

      List<Parent> parents =
          items.map<Parent>((i) => Parent.fromMap(i)).toList();

      parentsProvider.setParents(parents);

      emit(ParentsCubitSuccess());
    } else {
      print(result);
      emit(ParentsCubitFailure());
    }
  }

  Future<void> sendMessageToParents(
      List<String> ids, CreateMessageFrom form) async {
    for (var id in ids) {
      var result = await ApiCaller.request(
        url: '${ConstDataHelper.baseUrl}/parents/$id/messages',
        method: HttpMethod.POST,
        body: jsonEncode(form.toMap()),
        headers: ConstDataHelper.apiCommonHeaders,
      );

      if (result is Ok) {
        var messageId = jsonDecode(result.body)['outcome'];
        Message message = Message.fromMap({...form.toMap(), 'id': id});
        parentsProvider.addMessage(messageId, message);
      }
    }
  }
}
