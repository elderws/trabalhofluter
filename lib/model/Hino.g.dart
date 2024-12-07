// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Hino.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Hino _$HinoFromJson(Map<String, dynamic> json) => Hino(
  title: json['title'] as String,
  numero: (json['numero'] as num).toInt(),
  letra: json['letra'] as String,
);

Map<String, dynamic> _$HinoToJson(Hino instance) => <String, dynamic>{
  'title': instance.title,
  'numero': instance.numero,
  'letra': instance.letra,
};
