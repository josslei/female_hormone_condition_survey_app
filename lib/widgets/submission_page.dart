import 'package:flutter/material.dart';
import 'package:survey_app/survey_page_manager.dart';

class SubmissionPage extends StatefulWidget {
  final SurveyPageManager pageManager;

  const SubmissionPage({super.key, required this.pageManager});

  @override
  State<StatefulWidget> createState() => _SubmissionPage();
}

class _SubmissionPage extends State<SubmissionPage> {
  @override
  Widget build(BuildContext context) {
    Color appBarColor = Theme.of(context).colorScheme.primaryContainer;

    return Scaffold(
      appBar: AppBar(
        title: const Text('继续作答'),
        backgroundColor: appBarColor,
      ),
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
            Text(
              '问卷已填写完成，请确认是否提交。',
              style: TextStyle(fontSize: 24),
            ),
            Material(
                elevation: 6, // Shadow height
                shadowColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: OutlinedButton(
                  onPressed: () {
                    Widget resultPage = widget.pageManager.resultPage;
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => resultPage),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    side: BorderSide(
                        color: Theme.of(context).colorScheme.primaryContainer),
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                  child: const Text(
                    '提交问卷',
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ))
          ])),
    );
  }
}
