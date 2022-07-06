import 'package:json_annotation/json_annotation.dart';
import 'package:nobibot/models/group.order.dart';

import 'order.dart';

part 'group.order.req.g.dart';

@JsonSerializable()
class GroupOrderRequest {
  List<GroupOrder>? accounts;
  Order? order;

  GroupOrderRequest({
    this.accounts,
    this.order,
  });

  factory GroupOrderRequest.fromJson(Map<String, dynamic> json) =>
      _$GroupOrderRequestFromJson(json);
  Map<String, dynamic> toJson() => _$GroupOrderRequestToJson(this);
}
