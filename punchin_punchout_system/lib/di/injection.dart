import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';
import '../blocs/auth/auth_bloc.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // External Dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);

  // Services
  getIt.registerLazySingleton<StorageService>(
    () => StorageService(getIt<SharedPreferences>()),
  );
  getIt.registerLazySingleton<ApiService>(() => ApiService());

  // BLoCs
  getIt.registerFactory<AuthBloc>(
    () => AuthBloc(
      getIt<ApiService>(),
      getIt<StorageService>(),
    ),
  );
}
