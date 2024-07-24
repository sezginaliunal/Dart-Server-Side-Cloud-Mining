import 'package:json_annotation/json_annotation.dart';

part 'jwt.g.dart';

@JsonSerializable()
class Jwt {
  @JsonKey(name: '_id')
  final String? id;
  final String? token;
  final String? userId;

  Jwt({
    this.id,
    this.token,
    this.userId,
  });

  factory Jwt.fromJson(Map<String, dynamic> json) => _$JwtFromJson(json);

  Map<String, dynamic> toJson() => _$JwtToJson(this);
}
