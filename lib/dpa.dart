import 'dart:io';

import 'package:sirius/configuration.dart';
import 'package:sirius/i_dpa_repository.dart';
import 'package:sqflite/sqflite.dart';

///
/// keeps track of all registered repositories and their state
///
class DPA {
  static DPA _instance;
  static DPA get instance {
    if (_instance == null) _instance = DPA._();

    return _instance;
  }

  bool _readyForCRUD = false;

  Database _database;
  Future<Database> get database async {
    if (_database == null) {
      Directory rootDirectory = await Configuration.folderProvider.root;
      String pathToDb = "${rootDirectory.path}/.dpa/database.db";

      File dbFile = File(pathToDb);

      if (!dbFile.existsSync()) {
        dbFile.createSync(recursive: true);
        print("Successfully created database file.");
      } else
        print("Database file already exists.");

      _database = await openDatabase(dbFile.path);
    }

    if (!_readyForCRUD) {
      for (DPARepository repo in _registeredRepositories) {
        await _database.execute(repo.createQuery);
        print(repo.createQuery);
      }

      _readyForCRUD = true;
    }

    return _database;
  }

  ///
  /// Singleton -> private constructor
  ///
  DPA._();

  List<DPARepository> _registeredRepositories = [];

  Future<void> registerRepository(DPARepository repository) async {
    if (_readyForCRUD)
      throw Exception(
          "DPA is already initialized. Register your Repositories before starting any operations on the Database.");

    if (!_registeredRepositories.contains(repository)) {
      _registeredRepositories.add(repository);
      print("registered " + repository.runtimeType.toString());
    } else
      print(repository.runtimeType.toString() + " is already registered.");
  }
}
