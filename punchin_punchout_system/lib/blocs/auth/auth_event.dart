import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class CreateAccountEvent extends AuthEvent {
  final String username;
  final String password;

  const CreateAccountEvent({
    required this.username,
    required this.password,
  });

  @override
  List<Object?> get props => [username, password];
}

class PunchInEvent extends AuthEvent {
  final String userId;

  const PunchInEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class PunchOutEvent extends AuthEvent {
  final String userId;

  const PunchOutEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class CheckAuthEvent extends AuthEvent {}

class LogoutEvent extends AuthEvent {}
