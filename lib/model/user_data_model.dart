import 'package:json_annotation/json_annotation.dart';

part 'user_data_model.g.dart';

@JsonSerializable()
class UserData {
  @JsonKey(defaultValue: '-')
  String name;
  @JsonKey(defaultValue: '-')
  String phone;
  @JsonKey(defaultValue: '-')
  String email;
  @JsonKey(defaultValue: false)
  bool isDriver;
  UserData({this.name, this.phone, this.email, this.isDriver});

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}
