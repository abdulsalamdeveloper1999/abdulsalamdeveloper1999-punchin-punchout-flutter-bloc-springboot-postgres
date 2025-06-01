import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final String userId;

  const AuthAuthenticated(this.userId);

  @override
  List<Object?> get props => [userId];
}

class PunchSuccess extends AuthState {
  final String userId;
  final bool isPunchedIn;

  const PunchSuccess({
    required this.userId,
    required this.isPunchedIn,
  });

  @override
  List<Object?> get props => [userId, isPunchedIn];
}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}
