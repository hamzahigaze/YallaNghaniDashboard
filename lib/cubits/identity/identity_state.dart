part of 'identity_cubit.dart';

@immutable
abstract class IdentityState {}

class IdentityInitial extends IdentityState {}

class IdentityExist extends IdentityState {}

class IdentityNotExist extends IdentityState {}

class IdentityCheckInProgress extends IdentityState {}
