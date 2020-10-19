abstract class BaseDao<T> {

  String get createTableQuery;
  List<String> get updateQueries;
  List<String> get downgradeQueries;

  T fromMap(Map<String, dynamic> query);

  Map<String, dynamic> toMap(T object);

}
