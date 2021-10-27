part of 'teachers_cubit.dart';

@immutable
abstract class TeachersState {}

class TeachersInitial extends TeachersState {}

class TeachersSuccess extends TeachersState {}

class TeachersFailure extends TeachersState {}

class TeachersLoadInProgress extends TeachersState {}
