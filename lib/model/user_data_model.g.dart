// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserData _$UserDataFromJson(Map<String, dynamic> json) {
  return UserData(
    name: json['name'] as String ?? '-',
    phone: json['phone'] as String ?? '-',
    email: json['email'] as String ?? '-',
    isDriver: json['isDriver'] as bool ?? false,
  );
}

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
      'name': instance.name,
      'phone': instance.phone,
      'email': instance.email,
      'isDriver': instance.isDriver,
    };
