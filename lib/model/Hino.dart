import 'package:json_annotation/json_annotation.dart';

part 'Hino.g.dart';

@JsonSerializable()
class Hino {
  String title;
  int numero;
  String letra;

  Hino({required this.title, required this.numero, required this.letra});

  factory Hino.fromJson(Map<String, dynamic> json) => _$HinoFromJson(json);
  Map<String, dynamic> toJson() => _$HinoToJson(this);
}