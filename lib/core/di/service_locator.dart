import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../../data/repositories/api_post_repository.dart';
import '../../data/repositories/mock_post_repository.dart';
import '../../data/services/post_api_service.dart';
import '../../domain/repositories/post_repository.dart';

final sl = GetIt.instance; // sl stands for Service Locator

void setupLocator() {
  // Use 'true' to use the real API, 'false' to use the mock JSON file.
  const bool useApi = true;

  // Register services
  sl.registerLazySingleton<Dio>(() => Dio());
  sl.registerLazySingleton<PostApiService>(
    () => PostApiService(dio: sl<Dio>()),
  );

  // THE SWITCH
  if (useApi) {
    // Register the real API repository
    sl.registerLazySingleton<PostRepository>(
      () => ApiPostRepository(sl<PostApiService>()),
    );
  } else {
    // Register the mock repository that reads from the local JSON file
    sl.registerLazySingleton<PostRepository>(() => MockPostRepository());
  }
}
