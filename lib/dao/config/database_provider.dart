import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:skilla/dao/auth_dao.dart';
import 'package:skilla/dao/error_message_dao.dart';
import 'package:skilla/dao/user_dao.dart';

class DatabaseProvider {
  // ===== SINGLETON =====
  static final _instance = DatabaseProvider._internal();
  static DatabaseProvider get = _instance;

  //Never delete a version
  // ignore: non_constant_identifier_names
  static List<int> VERSIONS = [
    1, //Initial version
  ]; // Must increment by 1

  bool isInitialized = false;
  Database _db;

  DatabaseProvider._internal();

  // ===== GET DB INSTANCE =====
  Future<Database> db() async {
    if (!isInitialized) await _initDb();
    return _db;
  }

  // ===== INIT DB ======
  Future _initDb() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, "skilla.db");
    print(path);
    _db = await openDatabase(path, version: VERSIONS.last,
        onCreate: (Database db, int version) async {
      db.execute(ErrorMessageDAO.executeCreateTableQuery());
      db.execute(AuthDAO.executeCreateTableQuery());
      db.execute(UserDAO.executeCreateTableQuery());
    }, onUpgrade: (Database db, int oldVersion, int newVersion) async {
      // var updateTableQuery = PostDAO.UpdateTableQuery(oldVersion, newVersion);
      //if (updateTableQuery != null) db.execute(updateTableQuery);
    }, onDowngrade: (Database db, int oldVersion, int newVersion) async {
      // var downGradeTableQuery =
      // PostDAO.DownGradeTableQuery(oldVersion, newVersion);
      //  if (downGradeTableQuery != null) db.execute(downGradeTableQuery);
    });
  }
}
