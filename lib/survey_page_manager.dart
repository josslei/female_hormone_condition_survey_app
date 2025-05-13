import 'package:flutter/material.dart';

class SurveyPageManager {
  late final Widget startPage;
  late final Widget submissionPage;
  late final Widget resultPage;
  final int totalPages;

  final List<Widget> _surveyPageList;
  final List<String> _pageTitles;
  final List<int> _scoreBoard;

  SurveyPageManager({required this.totalPages})
      : _surveyPageList = <Widget>[]
      , _pageTitles = List.filled(totalPages, '')
      , _scoreBoard = List.filled(totalPages, 0);

  void setStartPage(Widget rhs) => startPage = rhs;
  Widget getStartPage() => startPage;

  void setSubmissionPage(Widget rhs) => submissionPage = rhs;
  Widget getSubmissionPage() => submissionPage;

  void setResultPage(Widget rhs) => resultPage = rhs;
  Widget getResultPage() => resultPage;

  // _scoreBoard operations
  void clearScoreBoard() => _scoreBoard.fillRange(0, _scoreBoard.length, 0);
  void updateScoreBoard(int i, int score) => _scoreBoard[i] = score;

  int getScore(int i) => _scoreBoard[i];

  // _pageTitles operations
  String getPageTitle(int i) => _pageTitles[i];
  void setPageTitle(int i, String title) => _pageTitles[i] = title;

  // _surveyPageList operations
  void addSurveyPage(Widget rhs) => _surveyPageList.add(rhs);

  Widget getPage(int i) => _surveyPageList[i];

  Widget getPrevPage(int i) {
    if (i == 0) {
      return startPage;
    }
    return _surveyPageList[i - 1];
  }

  Widget getNextPage(int i) {
    if (i == totalPages - 1) {
      return submissionPage;
    }
    return _surveyPageList[i + 1];
  }

  bool isNextSubmissionPage(int i) => i == totalPages - 1;
  bool isPrevStartPage(int i) => i == 0;
}
