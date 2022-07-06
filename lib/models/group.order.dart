import 'package:json_annotation/json_annotation.dart';

part 'group.order.g.dart';

@JsonSerializable()
class GroupOrder {
  String? token;
  double? ratio;

  GroupOrder({
    this.token,
    this.ratio,
  });

  factory GroupOrder.fromJson(Map<String, dynamic> json) =>
      _$GroupOrderFromJson(json);
  Map<String, dynamic> toJson() => _$GroupOrderToJson(this);
}
