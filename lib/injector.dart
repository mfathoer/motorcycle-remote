import 'package:get_it/get_it.dart';
import 'package:motorcycle_remote/data/remote/api_service.dart';
import 'package:motorcycle_remote/data/repository.dart';

GetIt getIt = GetIt.instance;

void setupDependencies() {
  getIt.registerSingleton(ApiService());
  getIt.registerSingleton(Repository(apiService: getIt<ApiService>()));
}
