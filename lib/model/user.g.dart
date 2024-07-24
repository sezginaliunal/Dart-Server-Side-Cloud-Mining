// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['_id'] as String?,
      pushNotificationId: json['pushNotificationId'] as String?,
      name: json['name'] as String?,
      surname: json['surname'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String?,
      transactions: (json['transactions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      wallets:
          (json['wallets'] as List<dynamic>?)?.map((e) => e as String).toList(),
      withdrawals: (json['withdrawals'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      accountStatus: (json['accountStatus'] as num?)?.toInt(),
      accountBalance: (json['accountBalance'] as num?)?.toDouble(),
      accountRole: (json['accountRole'] as num?)?.toInt(),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      '_id': instance.id,
      'pushNotificationId': instance.pushNotificationId,
      'name': instance.name,
      'surname': instance.surname,
      'email': instance.email,
      'password': instance.password,
      'transactions': instance.transactions,
      'wallets': instance.wallets,
      'withdrawals': instance.withdrawals,
      'accountStatus': instance.accountStatus,
      'accountBalance': instance.accountBalance,
      'accountRole': instance.accountRole,
    };
