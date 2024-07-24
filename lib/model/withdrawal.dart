import 'package:json_annotation/json_annotation.dart';
part 'withdrawal.g.dart';

@JsonSerializable()
class Withdrawal {
  @JsonKey(name: '_id')
  String? id;
  String? userId;
  String? walletId;
  double? quantity;
  int? status;

  Withdrawal({
    this.id,
    this.userId,
    this.walletId,
    this.quantity,
    this.status,
  });

  factory Withdrawal.fromJson(Map<String, dynamic> json) =>
      _$WithdrawalFromJson(json);

  Map<String, dynamic> toJson() => _$WithdrawalToJson(this);
}
