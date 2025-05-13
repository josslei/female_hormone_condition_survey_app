import 'package:flutter/material.dart';
import 'package:survey_app/survey_page_manager.dart';

class StartPage extends StatefulWidget {
  final SurveyPageManager pageManager;

  const StartPage({super.key, required this.pageManager});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    Color primaryContainerColor =
        Theme.of(context).colorScheme.primaryContainer;

    return Scaffold(
      appBar: AppBar(
        title: const Text('问卷首页'),
        backgroundColor: primaryContainerColor,
      ),
      body: Center(
          child: Material(
              elevation: 6, // Shadow height
              shadowColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: OutlinedButton(
                onPressed: () {
                  Widget next = widget.pageManager.getPage(0);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => next),
                  );
                },
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  side: BorderSide(color: primaryContainerColor),
                  backgroundColor: primaryContainerColor,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
                child: const Text(
                  '开始回答问卷',
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
              ))),
    );
  }
}
