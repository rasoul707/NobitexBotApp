import 'package:json_annotation/json_annotation.dart';
import './account.dart';
import 'group.order.response.dart';
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
  List<String>? pairs;
  List<ApiResponse>? groupOrder;

  ApiResponse({
    this.ok,
    this.code,
    this.message,
    this.addAccount,
    this.account,
    this.orders,
    this.properties,
    this.pairs,
    this.groupOrder,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) =>
      _$ApiResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ApiResponseToJson(this);
}
