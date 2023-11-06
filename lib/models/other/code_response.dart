import 'dart:convert';

CodeResponse codeResponseFromJson(String str) => CodeResponse.fromJson(json.decode(str));

String codeResponseToJson(CodeResponse data) => json.encode(data.toJson());

class CodeResponse {
    int id;
    String code;
    bool isVisitorImageRequired;
    bool isVistorIdImageRequired;
    bool isVisitorVehicleImageRequired;
    String residentName;
    int durationInHours;

    CodeResponse({
        required this.id,
        required this.code,
        required this.isVisitorImageRequired,
        required this.isVistorIdImageRequired,
        required this.isVisitorVehicleImageRequired,
        required this.residentName,
        required this.durationInHours,
    });

    factory CodeResponse.fromJson(Map<String, dynamic> json) => CodeResponse(
        id: json["id"],
        code: json["code"],
        isVisitorImageRequired: json["isVisitorImageRequired"],
        isVistorIdImageRequired: json["isVistorIdImageRequired"],
        isVisitorVehicleImageRequired: json["isVisitorVehicleImageRequired"],
        residentName: json["residentName"],
        durationInHours: json["durationInHours"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "isVisitorImageRequired": isVisitorImageRequired,
        "isVistorIdImageRequired": isVistorIdImageRequired,
        "isVisitorVehicleImageRequired": isVisitorVehicleImageRequired,
        "residentName": residentName,
        "durationInHours": durationInHours,
    };
}
