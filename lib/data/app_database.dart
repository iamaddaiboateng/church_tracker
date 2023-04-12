import 'dart:async';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class AppDatabase {
  // create database singleton
  static final AppDatabase _singleton = AppDatabase._();
  // create public accessor
  static AppDatabase get instance => _singleton;
  // create database completer
  Completer<Database> _dbOpenCompleter;
  // open completer if database is null
  Future<Database> get database async {
    if (_dbOpenCompleter == null) {
      _dbOpenCompleter = Completer();

      _openDatabase();
    }
    return _dbOpenCompleter.future;
  }

  Future _openDatabase() async {
    final appDirectory = await getApplicationDocumentsDirectory();
    final dbPath = join(appDirectory.path, 'members.db');
    final database = await databaseFactoryIo.openDatabase(dbPath);
    _dbOpenCompleter.complete(database);
  }

  AppDatabase._();
}
