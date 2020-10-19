import 'package:skilla/dao/config/base_dao.dart';
import 'package:skilla/dao/config/database_provider.dart';
import 'package:skilla/model/user.dart';
import 'package:skilla/network/config/base_response.dart';

class UserDAO implements BaseDao<User> {
  final String _tableName = "user";
  final String _columnId = "id";
  final String _columnFullName = "fullName";
  final String _columnUserName = "userName";
  final String _columnAvatar = "avatar";
  final String _columnEmail = "email";
  final String _columnBio = "bio";
  final String _columnWebsite = "website";

  @override
  String get createTableQuery => "CREATE TABLE $_tableName("
      "$_columnId CHAR(36) PRIMARY KEY, "
      "$_columnFullName TEXT,"
      "$_columnAvatar TEXT,"
      "$_columnEmail TEXT,"
      "$_columnBio TEXT,"
      "$_columnWebsite TEXT,"
      "$_columnUserName TEXT,)";

  @override
  List<String> get downgradeQueries => [''];

  @override
  List<String> get updateQueries => [''];

  static String executeUpdateTableQuery(int oldVersion, int newVersion) {
    return UserDAO()
        .updateQueries
        .sublist(oldVersion - 1, newVersion - 1)
        .join();
  }

  static String executeDownGradeTableQuery(int oldVersion, int newVersion) {
    return UserDAO()
        .downgradeQueries
        .sublist(oldVersion - 1, newVersion - 1)
        .join();
  }

  static String executeCreateTableQuery() {
    return UserDAO().createTableQuery;
  }

  @override
  User fromMap(Map<String, dynamic> query) {
    return User(
        id: query[_columnId],
        fullname: query[_columnFullName],
        avatar: query[_columnAvatar],
        email: query[_columnEmail],
        username: query[_columnUserName],
        bio: query[_columnBio],
        website: query[_columnWebsite]);
  }

  @override
  Map<String, dynamic> toMap(User object) {
    return <String, dynamic>{
      _columnId: object.id,
      _columnFullName: object.fullname,
      _columnUserName: object.username,
      _columnAvatar: object.avatar,
      _columnEmail: object.email,
      _columnBio: object.bio,
      _columnWebsite: object.website
    };
  }

  Future<BaseResponse<User>> save(User user) async {
    try {
      final db = await DatabaseProvider.get.db();
      await db.insert(_tableName, toMap(user));
      print("\n<<<<<<<<<< USER SAVED >>>>>>>>>>\n${user.toString()}\n");
      return BaseResponse.completed(data: user);
    } on Exception catch (identifier) {
      print("\n<<<<<<<<<< USER ERROR >>>>>>>>>>\n$identifier\n");
      return BaseResponse.error("$identifier");
    }
  }

  Future<BaseResponse<User>> update(User user) async {
    try {
      final db = await DatabaseProvider.get.db();
      await db.update(_tableName, toMap(user), where: "id = '${user.id}'");
      print("\n<<<<<<<<<< USER UPDATED >>>>>>>>>>\n${user.toString()}\n");
      return BaseResponse.completed(data: user);
    } on Exception catch (identifier) {
      print("\n<<<<<<<<<< USER ERROR >>>>>>>>>>\n$identifier\n");
      return BaseResponse.error("$identifier");
    }
  }

  Future<BaseResponse<User>> get() async {
    try {
      final db = await DatabaseProvider.get.db();
      var list = await db.query(_tableName);
      print("\n<<<<<<<<<< GET USER >>>>>>>>>>\n$list\n");

      if (list != null && list.isNotEmpty) {
        return BaseResponse.completed(data: fromMap(list.first));
      }

      return BaseResponse.completed(data: null);
    } on Exception catch (identifier) {
      print("\n<<<<<<<<<< USER ERROR >>>>>>>>>>\n$identifier\n");
      return BaseResponse.error("$identifier");
    }
  }

  Future<BaseResponse<dynamic>> cleanTable() async {
    try {
      final db = await DatabaseProvider.get.db();
      await db.delete(_tableName);
      print("\n<<<<<<<<<< USER DELETED >>>>>>>>>>\n");
      return BaseResponse.completed();
    } on Exception catch (identifier) {
      print("\n<<<<<<<<<< USER ERROR >>>>>>>>>>\n$identifier\n");
      return BaseResponse.error("$identifier");
    }
  }
}
