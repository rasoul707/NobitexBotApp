import 'package:json_annotation/json_annotation.dart';

import 'stage.dart';

part 'order.g.dart';

@JsonSerializable()
class Order {
  String? pair;
  String? type;
  String? actionType;

  double? amount;
  double? price;

  String? execution;
  double? stopPrice;

  double? totalAmount;
  List<Stage>? stages;

  Order({
    this.pair,
    this.type,
    this.actionType,
    this.amount,
    this.price,
    this.execution,
    this.stopPrice,
    this.totalAmount,
    this.stages,
  });

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
  Map<String, dynamic> toJson() => _$OrderToJson(this);
}
