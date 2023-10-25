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
  String? id;
  String? date;
  String? onTime;
  String? offTime;
  double? onVolume;
  double? offVolume;
  double? efficiency;
  String? source;
  String? remarks;

  PowerSupply({
    required this.id, required this.date, required this.onTime,
    required this.offTime, required this.onVolume, required this.offVolume,
    required this.efficiency, required this.source, this.remarks
  });

  Duration? get runtime {
    if (offTime != null && onTime != null) {
      return DateTime.parse(offTime!).difference(DateTime.parse(onTime!));
    } else {
      return null;
    }
  }

  factory PowerSupply.fromJson(Map<String, dynamic> json) => PowerSupply(
      id: json["id"],
      date: json["date"],
      onTime: json["onTime"],
      offTime: json["offTime"],
      onVolume: json["onVolume"]?.toDouble(),
      offVolume: json["offVolume"]?.toDouble(),
      efficiency: json["efficiency"]?.toDouble(),
      source: json["source"]
  );

}

List<PowerSource> parsePowerSources(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<PowerSource>((json) => PowerSource.fromJson(json)).toList();
}

List<PowerSupply> parsePowerSupply(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<PowerSupply>((json) => PowerSupply.fromJson(json)).toList();
}