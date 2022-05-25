import 'package:json_annotation/json_annotation.dart';

part 'account.g.dart';

@JsonSerializable()
class Account {
  int? id;
  String? label;
  String? email;
  String? password;
  String? token;
  String? device;
  String? profileName;
  double? balance;

  Account({
    this.id,
    this.label,
    this.email,
    this.password,
    this.token,
    this.device,
    this.profileName,
    this.balance,
  });

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);
  Map<String, dynamic> toJson() => _$AccountToJson(this);

  @override
  String toString() {
    return 'Account{id: $id, label: $label, email: $email, password: $password, token: $token, device: $device}';
  }
}

@JsonSerializable()
class AddAccountReq {
  String? email;
  String? password;

  AddAccountReq({
    this.email,
    this.password,
  });

  factory AddAccountReq.fromJson(Map<String, dynamic> json) =>
      _$AddAccountReqFromJson(json);
  Map<String, dynamic> toJson() => _$AddAccountReqToJson(this);
}

@JsonSerializable()
class AddAccountRes {
  String? token;
  String? device;

  AddAccountRes({
    this.token,
    this.device,
  });

  factory AddAccountRes.fromJson(Map<String, dynamic> json) =>
      _$AddAccountResFromJson(json);
  Map<String, dynamic> toJson() => _$AddAccountResToJson(this);
}