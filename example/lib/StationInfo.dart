// To parse this JSON data, do
//
//     final stationInfo = stationInfoFromJson(jsonString);

import 'dart:convert';

StationInfo stationInfoFromJson(String str) => StationInfo.fromJson(json.decode(str));

String stationInfoToJson(StationInfo data) => json.encode(data.toJson());

class StationInfo {
  StationInfo({
    this.cid,
    this.lac,
    this.mcc,
    this.mnc,
  });

  int cid;
  int lac;
  int mcc;
  int mnc;

  factory StationInfo.fromJson(Map<String, dynamic> json) => StationInfo(
    cid: json["CID"],
    lac: json["LAC"],
    mcc: json["MCC"],
    mnc: json["MNC"],
  );

  Map<String, dynamic> toJson() => {
    "CID": cid,
    "LAC": lac,
    "MCC": mcc,
    "MNC": mnc,
  };
}
