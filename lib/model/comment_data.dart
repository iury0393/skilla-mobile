import 'package:json_annotation/json_annotation.dart';

part 'comment_data.g.dart';

@JsonSerializable(explicitToJson: true)
class CommentData {
  String text;

  CommentData({this.text});

  factory CommentData.fromJson(Map<String, dynamic> json) =>
      _$CommentDataFromJson(json);

  Map<String, dynamic> toJson() => _$CommentDataToJson(this);

  @override
  String toString() {
    return "text: $text";
  }
}
