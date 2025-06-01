import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/api_service.dart';
import '../../services/storage_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final ApiService _apiService;
  final StorageService _storageService;

  AuthBloc(this._apiService, this._storageService) : super(AuthInitial()) {
    on<CreateAccountEvent>(_onCreateAccount);
    on<PunchInEvent>(_onPunchIn);
    on<PunchOutEvent>(_onPunchOut);
    on<CheckAuthEvent>(_onCheckAuth);
    on<LogoutEvent>(_onLogout);

    // Check for existing user when bloc is created
    add(CheckAuthEvent());
  }

  Future<void> _onCreateAccount(
    CreateAccountEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      final user =
          await _apiService.createAccount(event.username, event.password);
      await _storageService.saveUser(user);
      emit(AuthAuthenticated(user.id));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onPunchIn(
    PunchInEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      final timeLog = await _apiService.punchIn(event.userId);
      emit(PunchSuccess(
        userId: event.userId,
        isPunchedIn: true,
      ));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onPunchOut(
    PunchOutEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      final timeLog = await _apiService.punchOut(event.userId);
      emit(PunchSuccess(
        userId: event.userId,
        isPunchedIn: false,
      ));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onCheckAuth(
    CheckAuthEvent event,
    Emitter<AuthState> emit,
  ) async {
    final user = _storageService.getUser();
    if (user != null) {
      emit(AuthAuthenticated(user.id));
    } else {
      emit(AuthInitial());
    }
  }

  Future<void> _onLogout(
    LogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    await _storageService.clearUser();
    emit(AuthInitial());
  }
}
