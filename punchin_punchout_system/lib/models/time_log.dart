import 'package:equatable/equatable.dart';

class TimeLog extends Equatable {
  final String id;
  final String userId;
  final DateTime punchInTime;
  final DateTime? punchOutTime;

  const TimeLog({
    required this.id,
    required this.userId,
    required this.punchInTime,
    this.punchOutTime,
  });

  @override
  List<Object?> get props => [id, userId, punchInTime, punchOutTime];

  factory TimeLog.fromJson(Map<String, dynamic> json) {
    return TimeLog(
      id: json['id'].toString(),
      userId: json['userId'].toString(),
      punchInTime: DateTime.parse(json['punchIn'] as String),
      punchOutTime: json['punchOut'] != null
          ? DateTime.parse(json['punchOut'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'punchIn': punchInTime.toIso8601String(),
      'punchOut': punchOutTime?.toIso8601String(),
    };
  }
}
