import 'package:flutter/material.dart';

class UpdateItemRequest {
  final String? note;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;

  UpdateItemRequest({this.note, this.startTime, this.endTime});

  Map<String, dynamic> toJson() {
    // Chuyển TimeOfDay sang TimeOnly string "HH:mm:ss"
    String? formatTime(final TimeOfDay? t) => t != null
        ? "${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}:00"
        : null;

    return {
      'note': note,
      'startTime': formatTime(startTime),
      'endTime': formatTime(endTime),
    };
  }
}
