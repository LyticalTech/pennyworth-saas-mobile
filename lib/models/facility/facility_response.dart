import 'dart:convert';

class FacilityResponse {
  FacilityResponse({
    this.id,
    this.name,
    this.rate,
    this.description,
    this.estate,
    this.capacity,
    this.isAvailable,
  });

  FacilityResponse.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    rate = json['rate'];
    description = json['description'];
    estate = json['estate'];
    capacity = json['capacity'];
    isAvailable = json['isAvailable'];
  }

  String? id;
  String? name;
  double? rate;
  String? description;
  String? estate;
  int? capacity;
  bool? isAvailable;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['rate'] = rate;
    map['description'] = description;
    map['estate'] = estate;
    map['capacity'] = capacity;
    map['isAvailable'] = isAvailable;

    return map;
  }
}

List<FacilityResponse> parseFacilityResponse(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<FacilityResponse>((json) => FacilityResponse.fromJson(json)).toList();
}