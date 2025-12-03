import 'package:get_it/get_it.dart';
import 'package:smart_tourism_application/di/repository_module.dart';
import 'package:smart_tourism_application/di/service_module.dart';

final getIt = GetIt.instance;

class ServiceLocator {
  static Future<void> setup() async {
    // Setup repositories
    await RepositoryModule.setup();
    
    // Setup services
    ServiceModule.setup();
  }
}