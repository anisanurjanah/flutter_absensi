import 'dart:convert';

import 'package:flutter/foundation.dart';

class AttendanceResponseModel {
  final String? message;
  final List<Attendance>? data;

  AttendanceResponseModel({
    this.message,
    this.data,
  });

  factory AttendanceResponseModel.fromJson(String str) =>
      AttendanceResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AttendanceResponseModel.fromMap(Map<String, dynamic> json) =>
      AttendanceResponseModel(
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Attendance>.from(
                json["data"]!.map((x) => Attendance.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "message": message,
        "data":
            data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
      };

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AttendanceResponseModel &&
        other.message == message &&
        listEquals(other.data, data);
  }

  @override
  int get hashCode => message.hashCode ^ data.hashCode;
}

class Attendance {
  final int? id;
  final int? userId;
  final DateTime? date;
  final String? timeIn;
  final String? timeOut;
  final String? latlonIn;
  final String? latlonOut;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Attendance({
    this.id,
    this.userId,
    this.date,
    this.timeIn,
    this.timeOut,
    this.latlonIn,
    this.latlonOut,
    this.createdAt,
    this.updatedAt,
  });

  factory Attendance.fromJson(String str) =>
      Attendance.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Attendance.fromMap(Map<String, dynamic> json) => Attendance(
        id: json["id"] == null ? null : int.parse(json["id"].toString()),
        userId: json["user_id"] == null
            ? null
            : int.parse(json["user_id"].toString()),
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        timeIn: json["time_in"],
        timeOut: json["time_out"],
        latlonIn: json["latlon_in"],
        latlonOut: json["latlon_out"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "user_id": userId,
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "time_in": timeIn,
        "time_out": timeOut,
        "latlon_in": latlonIn,
        "latlon_out": latlonOut,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Attendance &&
        other.id == id &&
        other.userId == userId &&
        other.date == date &&
        other.timeIn == timeIn &&
        other.timeOut == timeOut &&
        other.latlonIn == latlonIn &&
        other.latlonOut == latlonOut &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        date.hashCode ^
        timeIn.hashCode ^
        timeOut.hashCode ^
        latlonIn.hashCode ^
        latlonOut.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
