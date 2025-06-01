import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/auth/auth_state.dart';
import '../services/api_service.dart';
import 'create_account_screen.dart';
import 'punch_in_screen.dart';

class TimerScreen extends StatefulWidget {
  final String userId;
  final bool isPunchedIn;

  const TimerScreen({
    super.key,
    required this.userId,
    required this.isPunchedIn,
  });

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  late Timer _timer;
  Duration _duration = Duration.zero;
  bool _isPunchedIn = true;
  final ApiService _apiService = ApiService();
  DateTime? _punchInTime;

  @override
  void initState() {
    super.initState();
    _isPunchedIn = widget.isPunchedIn;
    if (_isPunchedIn) {
      _initializeDuration();
    }
  }

  Future<void> _initializeDuration() async {
    try {
      final timeLog = await _apiService.getCurrentTimeLog(widget.userId);
      if (timeLog != null) {
        final now = DateTime.now();
        _punchInTime = timeLog.punchInTime;
        final elapsed = now.difference(timeLog.punchInTime);
        setState(() {
          _duration = elapsed;
        });
      }
      _startTimer();
    } catch (e) {
      // If there's an error, start from zero
      _startTimer();
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _duration += const Duration(seconds: 1);
      });
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  String _formatDateTime(DateTime dateTime) {
    final days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    final day = days[dateTime.weekday - 1];
    final date = '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    final time =
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    return '$day, $date at $time';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is PunchSuccess) {
            setState(() {
              _isPunchedIn = state.isPunchedIn;
              if (!state.isPunchedIn) {
                _timer.cancel();
              }
            });
            if (!state.isPunchedIn) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const PunchInScreen()),
              );
            }
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header with logout
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.logout, color: Colors.blue),
                      onPressed: () {
                        context.read<AuthBloc>().add(LogoutEvent());
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CreateAccountScreen()),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                // Timer Display
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Text(
                        _formatDuration(_duration),
                        style: const TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: _isPunchedIn
                              ? Colors.green.withOpacity(0.1)
                              : Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _isPunchedIn ? "Currently Working" : "Not Working",
                          style: TextStyle(
                            fontSize: 18,
                            color: _isPunchedIn ? Colors.green : Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                // Punch In Time
                if (_punchInTime != null) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.withOpacity(0.3)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Punch In Details',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _formatDateTime(_punchInTime!),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
                // Total Duration (when punched out)
                if (!_isPunchedIn) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Total Duration',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _formatDuration(_duration),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
                const Spacer(),
                // Action Button
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(
                            _isPunchedIn
                                ? PunchOutEvent(userId: widget.userId)
                                : PunchInEvent(userId: widget.userId),
                          );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isPunchedIn ? Colors.red : Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: Text(
                      _isPunchedIn ? 'Punch Out' : 'Punch In',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
