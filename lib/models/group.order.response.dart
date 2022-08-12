import 'package:json_annotation/json_annotation.dart';

part 'group.order.response.g.dart';

@JsonSerializable()
class GroupOrderResponse {
  bool? ok;
  String? result;

  GroupOrderResponse({
    this.ok,
    this.result,
  });

  factory GroupOrderResponse.fromJson(Map<String, dynamic> json) =>
      _$GroupOrderResponseFromJson(json);
  Map<String, dynamic> toJson() => _$GroupOrderResponseToJson(this);
}
