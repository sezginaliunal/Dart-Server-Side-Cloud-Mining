// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jwt.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Jwt _$JwtFromJson(Map<String, dynamic> json) => Jwt(
      id: json['_id'] as String?,
      token: json['token'] as String?,
      userId: json['userId'] as String?,
    );

Map<String, dynamic> _$JwtToJson(Jwt instance) => <String, dynamic>{
      '_id': instance.id,
      'token': instance.token,
      'userId': instance.userId,
    };
