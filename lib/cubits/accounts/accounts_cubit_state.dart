part of 'accounts_cubit_cubit.dart';

@immutable
abstract class AccountsCubitState {}

class AccountsCubitInitial extends AccountsCubitState {}

class AccountsCubitLoadInProgress extends AccountsCubitState {}

class AccountsCubitSuccess extends AccountsCubitState {}

class AccountsCubitFailure extends AccountsCubitState {}
