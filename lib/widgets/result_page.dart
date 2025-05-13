import 'package:flutter/material.dart';
import 'package:survey_app/survey_page_manager.dart';

class ResultPage extends StatefulWidget {
  final SurveyPageManager pageManager;

  const ResultPage({super.key, required this.pageManager});

  @override
  State<ResultPage> createState() => _ResultPage();
}

class _ResultPage extends State<ResultPage> {
  @override
  Widget build(BuildContext context) {
    Color primaryContainerColor =
        Theme.of(context).colorScheme.primaryContainer;

    return Scaffold(
        appBar: AppBar(
          title: const Text('测试结果'),
          backgroundColor: primaryContainerColor,
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '你的测试结果',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                        columns: const [
                          DataColumn(label: Text('Category')),
                          DataColumn(label: Text('Score')),
                          DataColumn(label: Text('Diagnostic')),
                        ],
                        rows: <DataRow>[
                          for (int i = 0; i < widget.pageManager.totalPages; i++)
                          DataRow(cells: [
                            DataCell(Text(widget.pageManager.getPageTitle(i))),
                            DataCell(Text(widget.pageManager.getScore(i).toString())),
                            // TODO: Diagnostics
                          ])
                        ]
                      ))
              ],
            )));
  }
}
