part of 'offered_courses_cubit.dart';

@immutable
abstract class OfferedCoursesState {}

class OfferedCoursesInitial extends OfferedCoursesState {}

class OfferedCoursesSuccess extends OfferedCoursesState {}

class OfferedCoursesFailure extends OfferedCoursesState {}

class OfferedCoursesLoadInProgress extends OfferedCoursesState {}
