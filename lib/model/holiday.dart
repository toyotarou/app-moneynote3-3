import 'dart:convert';

// TODO エラー修正できない
Map<String, String> holidayFromJson(String str) =>
    // ignore: inference_failure_on_instance_creation
    Map.from(json.decode(str) as Map<dynamic, dynamic>)
        .map((k, v) => MapEntry<String, String>(k as String, v as String));

// TODO エラー修正できない
// ignore: inference_failure_on_instance_creation
String holidayToJson(Map<String, String> data) => json.encode(Map.from(data)
    .map((k, v) => MapEntry<String, dynamic>(k as String, v as String)));

class Holiday {
  Holiday({required this.date, required this.content});

  String date;
  String content;
}
