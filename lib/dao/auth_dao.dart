import 'package:skilla/dao/config/base_dao.dart';
import 'package:skilla/dao/config/database_provider.dart';
import 'package:skilla/model/auth.dart';
import 'package:skilla/network/config/base_response.dart';

class AuthDAO implements BaseDao<Auth> {
  final String _tableName = "auth";
  final String _columnToken = "token";

  @override
  String get createTableQuery => "CREATE TABLE $_tableName("
      "$_columnToken TEXT)";

  @override
  List<String> get downgradeQueries => [''];

  @override
  List<String> get updateQueries => [''];

  static String executeUpdateTableQuery(int oldVersion, int newVersion) {
    return AuthDAO()
        .updateQueries
        .sublist(oldVersion - 1, newVersion - 1)
        .join();
  }

  static String executeDownGradeTableQuery(int oldVersion, int newVersion) {
    return AuthDAO()
        .downgradeQueries
        .sublist(oldVersion - 1, newVersion - 1)
        .join();
  }

  static String executeCreateTableQuery() {
    return AuthDAO().createTableQuery;
  }

  @override
  Auth fromMap(Map<String, dynamic> query) {
    return Auth(token: query[_columnToken]);
  }

  @override
  Map<String, dynamic> toMap(Auth object) {
    return <String, dynamic>{_columnToken: object.token};
  }

  Future<BaseResponse<Auth>> save(Auth auth) async {
    try {
      final db = await DatabaseProvider.get.db();
      await db.insert(_tableName, toMap(auth));
      print("\n<<<<<<<<<< AUTH SAVED >>>>>>>>>>\n${auth.toString()}\n");
      return BaseResponse.completed(data: auth);
    } on Exception catch (identifier) {
      print("\n<<<<<<<<<< AUTH ERROR >>>>>>>>>>\n$identifier\n");
      return BaseResponse.error("$identifier");
    }
  }

  Future<BaseResponse<Auth>> update(Auth auth) async {
    try {
      final db = await DatabaseProvider.get.db();
      await db.update(_tableName, toMap(auth),
          where: "token = '${auth.token}'");
      print("\n<<<<<<<<<< AUTH UPDATED >>>>>>>>>>\n${auth.toString()}\n");
      return BaseResponse.completed(data: auth);
    } on Exception catch (identifier) {
      print("\n<<<<<<<<<< AUTH ERROR >>>>>>>>>>\n$identifier\n");
      return BaseResponse.error("$identifier");
    }
  }

  Future<BaseResponse<Auth>> get() async {
    try {
      final db = await DatabaseProvider.get.db();
      var list = await db.query(_tableName);
      print("\n<<<<<<<<<< GET AUTH >>>>>>>>>>\n$list\n");

      if (list != null && list.isNotEmpty) {
        return BaseResponse.completed(data: fromMap(list.first));
      }

      return BaseResponse.completed(data: null);
    } on Exception catch (identifier) {
      print("\n<<<<<<<<<< AUTH ERROR >>>>>>>>>>\n$identifier\n");
      return BaseResponse.error("$identifier");
    }
  }

  Future<BaseResponse<dynamic>> cleanTable() async {
    try {
      final db = await DatabaseProvider.get.db();
      await db.delete(_tableName);
      print("\n<<<<<<<<<< AUTH DELETED >>>>>>>>>>\n");
      return BaseResponse.completed();
    } on Exception catch (identifier) {
      print("\n<<<<<<<<<< AUTH ERROR >>>>>>>>>>\n$identifier\n");
      return BaseResponse.error("$identifier");
    }
  }
}
