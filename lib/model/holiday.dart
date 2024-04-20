import 'dart:convert';

Map<dynamic, dynamic> holidayFromJson(String str) => Map.from(json.decode(str)).map(MapEntry<dynamic, dynamic>.new);

String holidayToJson(Map<String, String> data) => json.encode(Map.from(data).map(MapEntry<dynamic, dynamic>.new));

class Holiday {
  Holiday({required this.date, required this.content});

  String date;
  String content;
}
