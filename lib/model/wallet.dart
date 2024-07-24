import 'package:json_annotation/json_annotation.dart';
part 'wallet.g.dart';

@JsonSerializable()
class Wallet {
  @JsonKey(name: '_id')
  String id;
  String userId;
  String name;
  String address;
  String network;

  Wallet({
    required this.id,
    required this.userId,
    required this.name,
    required this.address,
    required this.network,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) => _$WalletFromJson(json);

  Map<String, dynamic> toJson() => _$WalletToJson(this);

  Wallet copyWith({
    String? id,
    String? name,
    String? address,
    String? network,
  }) {
    return Wallet(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      network: network ?? this.network,
      userId: '',
    );
  }
}
