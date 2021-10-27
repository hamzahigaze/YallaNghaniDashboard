import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:yalla_dashboard/helpers/const_data_helper.dart';
import 'package:yalla_dashboard/models/teachers/teacher.dart';
import 'package:yalla_dashboard/providers/teachers_provider.dart';
import 'package:yalla_dashboard/services/api_connection/api_connection_service.dart';

part 'teachers_state.dart';

class TeachersCubit extends Cubit<TeachersState> {
  TeachersCubit(this.teachersProvider) : super(TeachersInitial());

  TeachersProvider teachersProvider;
  String get apiPath => '${ConstDataHelper.baseUrl}/teachers';

  void fetchTeachers() async {
    emit(TeachersLoadInProgress());

    var result = await ApiCaller.request(
      url: '$apiPath',
      method: HttpMethod.GET,
      headers: ConstDataHelper.apiCommonHeaders,
    );
    if (result is Ok) {
      List<dynamic> items = jsonDecode(result.body)['outcome']['items'];

      List<Teacher> teachers =
          items.map<Teacher>((i) => Teacher.fromMap(i)).toList();

      teachersProvider.setTeachers(teachers);

      emit(TeachersSuccess());
    } else {
      print(result);
      emit(TeachersFailure());
    }
  }
}
