import 'package:json_annotation/json_annotation.dart';
import 'package:nobibot/models/account.dart';

part 'response.g.dart';

@JsonSerializable()
class ApiResponse {
  bool? ok;
  String? code;
  String? message;
  AddAccountRes? addAccount;
  Account? account;

  ApiResponse({
    this.ok,
    this.code,
    this.message,
    this.addAccount,
    this.account,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) =>
      _$ApiResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ApiResponseToJson(this);
}
