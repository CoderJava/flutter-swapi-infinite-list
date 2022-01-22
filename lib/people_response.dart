import 'package:json_annotation/json_annotation.dart';

part 'people_response.g.dart';

@JsonSerializable()
class PeopleResponse {
  @JsonKey(name: 'count')
  final int count;
  @JsonKey(name: 'next')
  final String? nextUrl;
  @JsonKey(name: 'previous')
  final String? previousUrl;
  @JsonKey(name: 'results')
  final List<ItemPeopleResponse> results;

  PeopleResponse({
    required this.count,
    required this.nextUrl,
    required this.previousUrl,
    required this.results,
  });

  factory PeopleResponse.fromJson(Map<String, dynamic> json) => _$PeopleResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PeopleResponseToJson(this);
}

@JsonSerializable()
class ItemPeopleResponse {
  @JsonKey(name: 'name')
  final String? name;
  @JsonKey(name: 'birth_year')
  final String? birthYear;
  @JsonKey(name: 'gender')
  final String? gender;

  ItemPeopleResponse({
    required this.name,
    required this.birthYear,
    required this.gender,
  });

  factory ItemPeopleResponse.fromJson(Map<String, dynamic> json) => _$ItemPeopleResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ItemPeopleResponseToJson(this);
}
