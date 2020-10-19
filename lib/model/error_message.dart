import 'package:json_annotation/json_annotation.dart';

part 'error_message.g.dart';

@JsonSerializable(explicitToJson: true)
class ErrorMessage {
  @JsonKey(ignore: true)
  int id;
  String code;
  String message;
  String lang;
  String lastUpdate;

  ErrorMessage({this.id, this.lastUpdate, this.code, this.message, this.lang});

  factory ErrorMessage.fromJson(Map<String, dynamic> json) =>
      _$ErrorMessageFromJson(json);

  Map<String, dynamic> toJson() => _$ErrorMessageToJson(this);

  @override
  String toString() {
    return 'lastUpdate: $lastUpdate, code: $code, lang: $lang message: $message';
  }
}
