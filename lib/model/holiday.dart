import 'dart:convert';

// TODO エラー修正できない
Map<String, String> holidayFromJson(String str) => Map.from(json.decode(str)).map((k, v) => MapEntry<String, String>(k, v));

// TODO エラー修正できない
String holidayToJson(Map<String, String> data) => json.encode(Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, v)));

class Holiday {
  Holiday({required this.date, required this.content});

  String date;
  String content;
}
