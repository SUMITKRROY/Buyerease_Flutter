part of 'login_cubit.dart';

@immutable
sealed class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final dynamic userData; // You can define a proper model instead of dynamic

  LoginSuccess(this.userData);
}

class LoginFailure extends LoginState {
  final String error;

  LoginFailure(this.error);
}