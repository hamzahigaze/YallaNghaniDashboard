part of 'parents_cubit.dart';

@immutable
abstract class ParentsState {}

class ParentsCubitInitial extends ParentsState {}

class ParentsCubitSuccess extends ParentsState {}

class ParentsCubitFailure extends ParentsState {}

class ParentsCubitLoadInProgress extends ParentsState {}
