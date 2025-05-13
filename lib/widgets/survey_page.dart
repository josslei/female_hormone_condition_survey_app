import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:survey_app/survey_page_manager.dart';
import 'package:survey_app/widgets/question_widget.dart';
import 'package:survey_app/questions.dart';

class SurveyPage extends StatefulWidget {
  final SurveyPageManager pageManager;

  final String title;
  final List<Question> questions;
  final Map<String, Question> dictionary;

  late final int pageIndex;
  late final int totalPages;

  SurveyPage(
      {super.key,
      required this.pageManager,
      required this.questions,
      this.title = ''})
      : dictionary = Map.fromIterable(questions, key: (q) => q.id);

  @override
  State<SurveyPage> createState() => _SurveyPageState();

  void setPageIndex(int i) {
    pageIndex = i;
    pageManager.setPageTitle(i, title);
  }
  void setTotalPages(int n) => totalPages = n;

  static Future<SurveyPage> fromJsonFile(
      String filePath, SurveyPageManager pageManager) async {
    final String response = await rootBundle.loadString(filePath);
    String title = jsonDecode(response)['title'];
    List<Question> questions = await Question.fromJsonFile(filePath);
    //await Future.delayed(Duration(seconds: 2));
    return SurveyPage(
        pageManager: pageManager, questions: questions, title: title);
  }
}

class _SurveyPageState extends State<SurveyPage> {
  @override
  void initState() {
    super.initState();
    _numMandatory = _countNumMandatory();
    _updateIsCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('第${widget.pageIndex + 1}/${widget.totalPages}页'),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        ),
        body: Column(
          children: [
            Expanded(
                child: ListView.builder(
                    itemCount: widget.questions.length,
                    itemBuilder: (context, index) {
                      final question = widget.questions[index];

                      // When the display of the question is conditioned by the
                      // answer of a previous question.
                      if (question.isConditioned() &&
                          widget.dictionary[question.condition!.$1]!.answer !=
                              question.condition!.$2) {
                        return SizedBox.shrink();
                      }

                      return QuestionWidget(
                          question: question,
                          onOptionSelected: (answer) {
                            setState(() {
                              question.answer = answer;
                              // If is the condition of another question
                              _setConditionedAnswerNull(question.id);
                              _numMandatory = _countNumMandatory();
                              _updateIsCompleted();
                            });
                          });
                    })),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FloatingActionButton(
                  // Prev page button
                  heroTag: 'prev_${widget.pageIndex}',
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                  onPressed: () {
                    // Navigate to the previous page
                    Widget prev =
                        widget.pageManager.getPrevPage(widget.pageIndex);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => prev),
                    );
                  },
                  child: Icon(Icons.arrow_back),
                ),
                FloatingActionButton(
                  // Next page button
                  heroTag: 'next_${widget.pageIndex}',
                  backgroundColor: _isCompleted
                      ? Theme.of(context).colorScheme.primaryContainer
                      : Colors.grey,
                  onPressed: () {
                    // Page not completed
                    if (!_isCompleted) {
                      return;
                    }
                    // Submit score
                    int score = _calculateScore();
                    widget.pageManager
                        .updateScoreBoard(widget.pageIndex, score);
                    // Navigate to the next page
                    Widget next =
                        widget.pageManager.getNextPage(widget.pageIndex);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => next),
                    );
                  },
                  child: Icon(Icons.arrow_forward),
                ),
              ],
            )
          ],
        ));
  }

  // Private helpers

  /// Questions' IDs must be in order and seamless (i.e., no integer shall be
  /// skipped). IDs' major number starts from 1.
  int _countNumMandatory() {
    int count = 0;
    for (var q in widget.questions) {
      if (q.isConditioned()) {
        if (widget.dictionary[q.condition!.$1]!.answer == q.condition!.$2) {
          count += 1;
        }
      } else {
        count += 1;
      }
    }
    return count;
  }

  void _setConditionedAnswerNull(String id) {
    for (var q in widget.questions) {
      if (q.isConditioned() && q.condition!.$1 == id) {
        q.answer = null;
      }
    }
  }

  void _updateIsCompleted() {
    int numAnswered = 0;
    int curIndex = 0;
    int curCount = 0;
    for (var q in widget.questions) {
      if (curIndex != q.getMajorNumber()) {
        numAnswered += curCount;
        curIndex = q.getMajorNumber();
        curCount = 0;
      }
      // Dealing with the exclusive sublist
      if (q.isExclusive()) {
        // Skip if one question in the sublist is answered
        if (curCount == 0) {
          curCount = q.isAnswered() ? 1 : 0;
        }
      }
      // Dealing with the non-exclusive sublist
      else if (q.isSublist()) {
        curCount += q.isAnswered() ? 1 : 0;
      }
      // Normal isolated multiple choice question
      else {
        curCount = q.isAnswered() ? 1 : 0;
      }
    }
    numAnswered += curCount;
    // Update status
    _isCompleted = numAnswered == _numMandatory;
  }

  int _calculateScore() {
    int score = 0;
    for (var q in widget.questions) {
      score += q.isAnswered() ? q.getScore()! : 0;
    }
    return score;
  }

  // Properties
  int _numMandatory = 0;
  bool _isCompleted = false;
}
