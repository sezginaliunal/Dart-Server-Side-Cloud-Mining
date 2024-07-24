import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  @JsonKey(name: '_id')
  String? id;
  String? pushNotificationId;
  String? name;
  String? surname;
  String? email;
  String? password;
  List<String>? transactions;
  List<String>? wallets;
  List<String>? withdrawals;
  int? accountStatus;
  double? accountBalance;
  int? accountRole;

  User({
    this.id,
    this.pushNotificationId,
    this.name,
    this.surname,
    this.email,
    this.password,
    this.transactions,
    this.wallets,
    this.withdrawals,
    this.accountStatus,
    this.accountBalance,
    this.accountRole,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  User copyWith({
    String? id,
    String? name,
    String? surname,
    String? email,
    List<String>? transactions,
    List<String>? wallets,
    List<String>? withdrawals,
    int? accountStatus,
    double? accountBalance,
    int? accountRole,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      email: email ?? this.email,
      transactions: transactions ?? this.transactions,
      wallets: wallets ?? this.wallets,
      withdrawals: withdrawals ?? this.withdrawals,
      accountStatus: accountStatus ?? this.accountStatus,
      accountBalance: accountBalance ?? this.accountBalance,
      accountRole: accountRole ?? this.accountRole,
    );
  }
}
