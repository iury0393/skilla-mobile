import 'package:sqflite/sqflite.dart';
import 'package:skilla/dao/config/base_dao.dart';
import 'package:skilla/dao/config/database_provider.dart';
import 'package:skilla/model/base_error.dart';
import 'package:skilla/model/error_message.dart';
import 'package:skilla/network/config/base_response.dart';
import 'package:skilla/utils/utils.dart';

class ErrorMessageDAO implements BaseDao<ErrorMessage> {
  final String _tableName = "errors";
  final String _columnId = "id";
  final String _columnLastUpdate = "lastUpdate";
  final String _columnMessage = "message";
  final String _columnLang = "lang";
  final String _columnCode = "code";

  @override
  String get createTableQuery => "CREATE TABLE $_tableName("
      "$_columnId INTEGER PRIMARY KEY, "
      "$_columnLastUpdate TEXT, "
      "$_columnMessage TEXT, "
      "$_columnLang TEXT, "
      "$_columnCode TEXT)";

  @override
  List<String> get downgradeQueries => [''];

  @override
  List<String> get updateQueries => [''];

  static String executeUpdateTableQuery(int oldVersion, int newVersion) {
    return ErrorMessageDAO()
        .updateQueries
        .sublist(oldVersion - 1, newVersion - 1)
        .join();
  }

  static String executeDownGradeTableQuery(int oldVersion, int newVersion) {
    return ErrorMessageDAO()
        .downgradeQueries
        .sublist(oldVersion - 1, newVersion - 1)
        .join();
  }

  static String executeCreateTableQuery() {
    return ErrorMessageDAO().createTableQuery;
  }

  @override
  ErrorMessage fromMap(Map<String, dynamic> query) {
    return ErrorMessage(
        id: query[_columnId],
        code: query[_columnCode],
        message: query[_columnMessage],
        lang: query[_columnLang]);
  }

  @override
  Map<String, dynamic> toMap(ErrorMessage object) {
    return <String, dynamic>{
      _columnId: object.id,
      _columnLastUpdate: object.lastUpdate,
      _columnMessage: object.message,
      _columnLang: object.lang,
      _columnCode: object.code
    };
  }

  Future<BaseResponse<dynamic>> save(BaseError baseError) async {
    try {
      final db = await DatabaseProvider.get.db();
      await db.transaction((txn) async {
        var batch = db.batch();
        baseError.messages.forEach((message) async {
          var m = ErrorMessage(
              lastUpdate: baseError.lastUpdate,
              code: message.code,
              lang: message.lang,
              message: message.message);
          await db.insert(_tableName, toMap(m),
              conflictAlgorithm: ConflictAlgorithm.replace);
        });
        batch.commit();
      });
      print(
          "\n<<<<<<<<<< ERROR MESSAGES SAVED >>>>>>>>>>\n${baseError.toString()}\n");
      return BaseResponse.completed();
    } on Exception catch (identifier) {
      print("\n<<<<<<<<<< ERROR MESSAGES ERROR  >>>>>>>>>>\n$identifier\n");
      return BaseResponse.error("$identifier");
    }
  }

  Future<BaseResponse<ErrorMessage>> getMessageByCode(String code) async {
    if (code.length > 8) {
      return BaseResponse.completed(data: null);
    }

    var lang = "";
    if (Utils.appLanguage.contains("pt")) {
      lang = "pt-BR";
    } else {
      lang = Utils.appLanguage;
    }

    try {
      final db = await DatabaseProvider.get.db();
      var list = await db.query(
        _tableName,
        where: '$_columnCode = ? AND $_columnLang = ?',
        whereArgs: [code, lang],
      );
      print(
          "\n<<<<<<<<<< GET ERROR MESSAGE BY CODE >>>>>>>>>>\n${list.toString()}\n}");

      if (list != null && list.isNotEmpty) {
        ErrorMessage errorMessage = ErrorMessage.fromJson(list.first);
        return BaseResponse.completed(data: errorMessage);
      }

      return BaseResponse.completed(data: null);
    } on Exception catch (identifier) {
      print("\n<<<<<<<<<< ERROR MESSAGES ERROR  >>>>>>>>>>\n$identifier\n");
      return BaseResponse.error("$identifier");
    }
  }

  Future<BaseResponse<List<ErrorMessage>>> getAllMessages() async {
    try {
      final db = await DatabaseProvider.get.db();
      var list = await db.query(_tableName);
      print("\n===== GET MESSAGES =====\n$list\n");

      if (list != null && list.isNotEmpty) {
        List<ErrorMessage> messages = List<ErrorMessage>();
        list.forEach((element) {
          messages.add(ErrorMessage.fromJson(element));
        });
        return BaseResponse.completed(data: messages);
      }

      return BaseResponse.completed(data: List<ErrorMessage>());
    } on Exception catch (identifier) {
      print("\n<<<<<<<<<< ERROR MESSAGES ERROR  >>>>>>>>>>\n$identifier\n");
      return BaseResponse.error("$identifier");
    }
  }

  Future<BaseResponse<dynamic>> cleanTable() async {
    try {
      final db = await DatabaseProvider.get.db();
      await db.delete(_tableName);
      print("\n<<<<<<<<<< ERROR MESSAGES DELETED >>>>>>>>>>\n");
      return BaseResponse.completed();
    } on Exception catch (identifier) {
      print("\n<<<<<<<<<< ERROR MESSAGES ERROR >>>>>>>>>>\n$identifier\n");
      return BaseResponse.error("$identifier");
    }
  }
}
