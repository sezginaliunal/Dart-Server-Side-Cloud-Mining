import 'package:json_annotation/json_annotation.dart';
part 'transaction.g.dart';

@JsonSerializable()
class Transaction {
  @JsonKey(name: '_id')
  String? id;
  String? userId;
  DateTime? startTime;
  DateTime? endTime;
  bool? isActive;
  double? price;

  Transaction({
    this.id,
    this.userId,
    this.startTime,
    this.endTime,
    this.isActive,
    this.price,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionToJson(this);

// Assuming you have a method where you receive the data
  List<Transaction> parseTransactions(List<Map<String, dynamic>> data) {
    return data.map((json) => Transaction.fromJson(json)).toList();
  }
}
