import 'dart:core';
import 'dart:convert';
import 'package:flutter/services.dart';

class Question {
  final String id;
  final String text;
  final Map<String, int> options;
  (String, String)? condition;
  String? answer;

  Question(
      {required this.id,
      required this.text,
      required this.options,
      this.condition,
      this.answer});

  factory Question.fromJson(Map<String, dynamic> jsonMap) {
    (String, String)? condition = jsonMap.containsKey('condition')
        ? (jsonMap['condition'][0], jsonMap['condition'][1])
        : null;
    return Question(
        id: jsonMap['id'],
        text: jsonMap['text'],
        options: jsonMap['options'].cast<String, int>(),
        condition: condition,
        answer: null);
  }

  static Future<List<Question>> fromJsonFile(String path) async {
    final String response = await rootBundle.loadString(path);
    final List<dynamic> qList = jsonDecode(response)['questions'];
    return qList.map((json) => Question.fromJson(json)).toList();
  }

  bool isAnswered() => answer != null;
  int? getScore() => isAnswered() ? options[answer] : null;

  bool isConditioned() => condition != null;
  bool isExclusive() => RegExp(r'\d+-[a-z]+$').hasMatch(id);
  bool isSublist() => RegExp(r'\d+-\d+$').hasMatch(id);
  int getMajorNumber() {
    int? endIndex = id.indexOf('-');
    if (endIndex == -1) {
      endIndex = null;
    }
    return int.parse(id.substring(0, endIndex));
  }
}
