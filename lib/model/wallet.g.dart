// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Wallet _$WalletFromJson(Map<String, dynamic> json) => Wallet(
      id: json['_id'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      network: json['network'] as String,
    );

Map<String, dynamic> _$WalletToJson(Wallet instance) => <String, dynamic>{
      '_id': instance.id,
      'userId': instance.userId,
      'name': instance.name,
      'address': instance.address,
      'network': instance.network,
    };
