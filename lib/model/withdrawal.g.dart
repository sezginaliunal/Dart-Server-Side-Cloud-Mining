// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'withdrawal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Withdrawal _$WithdrawalFromJson(Map<String, dynamic> json) => Withdrawal(
      id: json['_id'] as String?,
      userId: json['userId'] as String?,
      walletId: json['walletId'] as String?,
      quantity: (json['quantity'] as num?)?.toDouble(),
      status: (json['status'] as num?)?.toInt(),
    );

Map<String, dynamic> _$WithdrawalToJson(Withdrawal instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'userId': instance.userId,
      'walletId': instance.walletId,
      'quantity': instance.quantity,
      'status': instance.status,
    };
