import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:offs/core/database/database.dart';

@module
abstract class RegisterModule {
  @lazySingleton
  AppDatabase get appDatabase => AppDatabase();

  @lazySingleton
  Dio get dio => Dio();
}
