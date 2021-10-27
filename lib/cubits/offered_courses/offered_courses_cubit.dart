import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:yalla_dashboard/helpers/const_data_helper.dart';
import 'package:yalla_dashboard/models/offered_courses/offered_course.dart';
import 'package:yalla_dashboard/providers/offered_courses_provider.dart';
import 'package:yalla_dashboard/services/api_connection/api_connection_service.dart';

part 'offered_courses_state.dart';

class OfferedCoursesCubit extends Cubit<OfferedCoursesState> {
  OfferedCoursesCubit(this.offeredCoursesProvider)
      : super(OfferedCoursesInitial());

  OfferedCoursesProvider offeredCoursesProvider;
  String get apiPath => '${ConstDataHelper.baseUrl}/offeredcourses';

  void fetchOfferedCourses() async {
    emit(OfferedCoursesLoadInProgress());

    var result = await ApiCaller.request(
      url: '$apiPath',
      method: HttpMethod.GET,
      headers: ConstDataHelper.apiCommonHeaders,
    );
    if (result is Ok) {
      List<dynamic> items = jsonDecode(result.body)['outcome'];

      List<OfferedCourse> offeredCourse =
          items.map<OfferedCourse>((i) => OfferedCourse.fromMap(i)).toList();

      offeredCoursesProvider.setCourses(offeredCourse);

      emit(OfferedCoursesSuccess());
    } else {
      print(result);
      emit(OfferedCoursesFailure());
    }
  }

  Future<List<String>> fetchCoursesNames() async {
    var result = await ApiCaller.request(
      url: '${ConstDataHelper.baseUrl}/offeredcourses',
      method: HttpMethod.GET,
      headers: ConstDataHelper.apiCommonHeaders,
    );

    if (result is Ok) {
      print('Succeeded fetching courses names');

      var coursesData = jsonDecode(result.body)['outcome'];

      return coursesData.map<String>((t) {
        return t['title'] as String;
      }).toList();
    } else {
      print('Failed fetching courses names ');
      print(result);

      return null;
    }
  }
}
