import 'dart:convert';

class FacilityResponse {
  FacilityResponse({
    this.id,
    this.name,
    this.ratePerHour,
    this.description,
    this.estate,
    this.capacity,
    this.isAvailable,
  });

  FacilityResponse.fromJson(dynamic json) {
    id = json['id'] as int;
    name = json['name'];
    ratePerHour = json['ratePerHour'];
    description = json['description'];
    estate = json['estate'];
    estateId = json['estateId'];
    capacity = json['capacity'];
    isAvailable = json['isAvailable'];
  }

  int? id;
  String? name;
  double? ratePerHour;
  String? description;
  String? estate;
  int? estateId;
  int? capacity;
  bool? isAvailable;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['rate'] = ratePerHour;
    map['description'] = description;
    map['estate'] = estate;
    map['capacity'] = capacity;
    map['isAvailable'] = isAvailable;

    return map;
  }
}

List<FacilityResponse> parseFacilityResponse(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed
      .map<FacilityResponse>((json) => FacilityResponse.fromJson(json))
      .toList();
}
