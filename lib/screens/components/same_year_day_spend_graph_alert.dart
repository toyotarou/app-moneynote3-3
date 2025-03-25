import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class SameYearDaySpendGraphAlert extends ConsumerStatefulWidget {
  const SameYearDaySpendGraphAlert({
    super.key,
    required this.yearList,
    required this.graphData,
  });

  final List<String> yearList;
  final Map<String, Map<String, int>> graphData;

  @override
  ConsumerState<SameYearDaySpendGraphAlert> createState() => _SameYearDaySpendGraphAlertState();
}

class _SameYearDaySpendGraphAlertState extends ConsumerState<SameYearDaySpendGraphAlert> {
  LineChartData graphData = LineChartData();

  String selectedYear = '';

  ///
  @override
  void initState() {
    super.initState();

    selectedYear = widget.yearList[0];
  }

  ///
  @override
  Widget build(BuildContext context) {
    _setChartData();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: DefaultTextStyle(
          style: GoogleFonts.kiwiMaru(fontSize: 12),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20),
              const Text('年別同日収支金額'),
              Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
              SizedBox(
                height: 50,
                child: Row(
                  children: <Widget>[
                    const Expanded(child: SizedBox.shrink()),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: widget.yearList.map(
                          (String e) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              child: GestureDetector(
                                onTap: () => setState(() => selectedYear = e),
                                child: CircleAvatar(
                                  backgroundColor: (selectedYear == e)
                                      ? Colors.yellowAccent.withOpacity(0.2)
                                      : Colors.white.withOpacity(0.2),
                                  child: Text(e, style: const TextStyle(fontSize: 12, color: Colors.black)),
                                ),
                              ),
                            );
                          },
                        ).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(child: LineChart(graphData)),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  ///
  void _setChartData() {
    graphData = LineChartData(
      ///
      titlesData: const FlTitlesData(show: false),
    );
  }
}
