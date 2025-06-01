import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String username;
  final String password;

  const User({
    required this.id,
    required this.username,
    required this.password,
  });

  @override
  List<Object?> get props => [id, username, password];

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      password: json['password']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'password': password,
    };
  }
}
