import 'package:json_annotation/json_annotation.dart';
import 'package:skilla/model/error_message.dart';

part 'base_error.g.dart';

@JsonSerializable(explicitToJson: true)
class BaseError {
  String lastUpdate;
  List<ErrorMessage> messages;

  BaseError({this.lastUpdate, this.messages});

  factory BaseError.fromJson(Map<String, dynamic> json) =>
      _$BaseErrorFromJson(json);

  Map<String, dynamic> toJson() => _$BaseErrorToJson(this);

  @override
  String toString() {
    return 'lastUpdate: $lastUpdate, messagesLength: ${messages.length}';
  }
}
