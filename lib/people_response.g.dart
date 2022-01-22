// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'people_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PeopleResponse _$PeopleResponseFromJson(Map<String, dynamic> json) =>
    PeopleResponse(
      count: json['count'] as int,
      nextUrl: json['next'] as String?,
      previousUrl: json['previous'] as String?,
      results: (json['results'] as List<dynamic>)
          .map((e) => ItemPeopleResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PeopleResponseToJson(PeopleResponse instance) =>
    <String, dynamic>{
      'count': instance.count,
      'next': instance.nextUrl,
      'previous': instance.previousUrl,
      'results': instance.results,
    };

ItemPeopleResponse _$ItemPeopleResponseFromJson(Map<String, dynamic> json) =>
    ItemPeopleResponse(
      name: json['name'] as String?,
      birthYear: json['birth_year'] as String?,
      gender: json['gender'] as String?,
    );

Map<String, dynamic> _$ItemPeopleResponseToJson(ItemPeopleResponse instance) =>
    <String, dynamic>{
      'name': instance.name,
      'birth_year': instance.birthYear,
      'gender': instance.gender,
    };
