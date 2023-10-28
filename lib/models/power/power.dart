import 'dart:convert';

class PowerSource {
  String? id;
  String? name;
  int? capacity;
  int? volume;

  PowerSource({required this.id, required this.name, required this.capacity, required this.volume});

  factory PowerSource.fromJson(Map<String, dynamic> json) => PowerSource(
      id: json["id"],
      name: json["name"],
      capacity: json["capacity"],
      volume: json["volume"]
  );
}

class PowerSupply {
  int id;
  String date;
  String? onTime;
  double onVolume;
  String? offTime;
  String? offRemarks;
  double offVolume;
  String? onRemarks;
  double? efficiency;
  String source;
  String estate;
  int estateId;

  PowerSupply({
    required this.id,
    required this.date,
    required this.onTime,
    required this.onVolume,
    this.offTime,
    this.offRemarks,
    required this.onRemarks,
    required this.offVolume,
    this.efficiency,
    required this.source,
    required this.estate,
    required this.estateId,
  });

  factory PowerSupply.fromJson(Map<String, dynamic> json) {
    return PowerSupply(
      id: json['id'],
      date: json['date'],
      onTime: json['onTime'],
      onVolume: json['onVolume'].toDouble(),
      offTime: json['offTime'],
      offRemarks: json['offRemarks'],
      onRemarks: json['onRemarks'],
      offVolume: json['offVolume'].toDouble(),
      efficiency: json['efficiency']?.toDouble(),
      source: json['source'],
      estate: json['estate'],
      estateId: json['estateId'],
    );
  }

    Duration? get runtime {
    if (offTime != null && onTime != null) {
      DateTime on = DateTime.parse(onTime!);
      DateTime off = DateTime.parse(offTime!);
      return off.difference(on);
    } else {
      return null;
    }
  }
}




List<PowerSupply> parsePowerSupply(String responseBody) {
  final List<dynamic> parsed = jsonDecode(responseBody);
  return parsed.map<PowerSupply>((json) => PowerSupply.fromJson(json)).toList();
}

List<PowerSource> parsePowerSources(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<PowerSource>((json) => PowerSource.fromJson(json)).toList();
}
