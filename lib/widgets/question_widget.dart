import 'package:flutter/material.dart';
import 'package:survey_app/questions.dart';

class QuestionWidget extends StatelessWidget {
  final Question question;
  final ValueChanged<String?> onOptionSelected;

  const QuestionWidget({
    super.key,
    required this.question,
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question.text,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ...question.options.keys.map((option) {
              return RadioListTile<String>(
                title: Text(option),
                value: option,
                groupValue: question.answer,
                onChanged: onOptionSelected,
              );
            }),
          ],
        ),
      ),
    );
  }
}
