import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? niceName;
  String? displayName;
  String? username;
  int? confirmed;
  int? pending;

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.niceName,
    this.displayName,
    this.username,
    this.confirmed,
    this.pending,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

//

@JsonSerializable()
class LoginReq {
  String? username;
  String? password;

  LoginReq({this.username, this.password});

  factory LoginReq.fromJson(Map<String, dynamic> json) =>
      _$LoginReqFromJson(json);
  Map<String, dynamic> toJson() => _$LoginReqToJson(this);
}

//

@JsonSerializable()
class LoginRes {
  String? token;
  User? user;

  LoginRes({this.token, this.user});

  factory LoginRes.fromJson(Map<String, dynamic> json) =>
      _$LoginResFromJson(json);
  Map<String, dynamic> toJson() => _$LoginResToJson(this);
}

//

