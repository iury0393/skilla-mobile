import 'package:json_annotation/json_annotation.dart';

part 'error_response.g.dart';

@JsonSerializable(explicitToJson: true)
class ErrorResponse {
  List<String> errors;

  ErrorResponse(this.errors);

  factory ErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$ErrorResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ErrorResponseToJson(this);

  @override
  String toString() {
    return 'errorsLength: ${errors.length}';
  }
}
