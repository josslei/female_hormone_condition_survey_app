import 'package:flutter/material.dart';
import 'package:survey_app/survey_page_manager.dart';
import 'package:survey_app/widgets/start_page.dart';
import 'package:survey_app/widgets/submission_page.dart';
import 'package:survey_app/widgets/survey_page.dart';

const List<String> QUESTION_SETS = <String>[
  'estrogen.json',
  'thyroid.json',
  'pregnenolone.json',
  'melatonin.json',
  'somatotropin.json',
  'progesterone.json',
  'testosterone.json'
];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(AppMain());
}

class AppMain extends StatefulWidget {
  const AppMain({super.key});

  @override
  State<StatefulWidget> createState() => _AppMain();
}

class _AppMain extends State<AppMain> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var pageManager = SurveyPageManager(totalPages: QUESTION_SETS.length);
    var startPage = StartPage(pageManager: pageManager);
    var submissionPage = SubmissionPage(pageManager: pageManager);
    pageManager.setStartPage(startPage);
    pageManager.setSubmissionPage(submissionPage);
    QUESTION_SETS.asMap().forEach((index, fname) {
      pageManager.addSurveyPage(loadSurveyPage(
          'question_sets/$fname', pageManager, index, QUESTION_SETS.length));
    });

    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'SimSun',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: pageManager.getStartPage(),
    );
  }

  FutureBuilder<SurveyPage> loadSurveyPage(String pathQuestionJson,
      SurveyPageManager pageManager, int pageIndex, int totalPages) {
    return FutureBuilder(
      future:
          SurveyPage.fromJsonFile(pathQuestionJson, pageManager).then((page) {
        page.setPageIndex(pageIndex);
        page.setTotalPages(totalPages);
        return page;
      }),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Loading
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          // Error handling
          return Scaffold(
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        } else if (snapshot.hasData) {
          // Survey questions loaded
          return snapshot.data!;
        } else {
          // Unknown status
          return Scaffold(
            body: Center(
              child: Text('No data available'),
            ),
          );
        }
      },
    );
  }
}
