import 'package:json_annotation/json_annotation.dart';
part 'default.g.dart';

@JsonSerializable()
class Default {
  @JsonKey(name: '_id')
  String? id;
  String? name;
  dynamic value;

  Default({
    this.id,
    this.name,
    this.value,
  });

  factory Default.fromJson(Map<String, dynamic> json) =>
      _$DefaultFromJson(json);

  Map<String, dynamic> toJson() => _$DefaultToJson(this);
}
