import 'package:json_annotation/json_annotation.dart';
import './account.dart';
import 'order.dart';
import 'property.dart';

part 'response.g.dart';

@JsonSerializable()
class ApiResponse {
  bool? ok;
  String? code;
  String? message;
  AddAccountRes? addAccount;
  Account? account;
  List<Order>? orders;
  List<Property>? properties;

  ApiResponse({
    this.ok,
    this.code,
    this.message,
    this.addAccount,
    this.account,
    this.orders,
    this.properties,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) =>
      _$ApiResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ApiResponseToJson(this);
}
