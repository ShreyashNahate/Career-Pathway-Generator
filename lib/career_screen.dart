import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:projectx/government_colleges_map.dart';

class CareerScreen extends StatelessWidget {
  const CareerScreen({super.key, required this.initialStream});
  final String initialStream;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      initialIndex: _getInitialTabIndex(initialStream),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Career Courses & Paths'),
          bottom: const TabBar(
            isScrollable: true,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'Arts'),
              Tab(text: 'Science'),
              Tab(text: 'Commerce'),
              Tab(text: 'Vocational'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _StreamDetails(stream: 'Arts'),
            _StreamDetails(stream: 'Science'),
            _StreamDetails(stream: 'Commerce'),
            _StreamDetails(stream: 'Vocational'),
          ],
        ),
      ),
    );
  }

  int _getInitialTabIndex(String stream) {
    switch (stream) {
      case 'Science':
        return 1;
      case 'Commerce':
        return 2;
      case 'Vocational':
        return 3;
      case 'Arts':
      default:
        return 0;
    }
  }
}

class _StreamDetails extends StatelessWidget {
  final String stream;

  const _StreamDetails({required this.stream});

  @override
  Widget build(BuildContext context) {
    final data = {
      'Arts': [
        {'course': 'B.A.', 'jobs': 7, 'higher': 5, 'govt': 3},
        {'course': 'BBA', 'jobs': 6, 'higher': 4, 'govt': 2},
      ],
      'Science': [
        {'course': 'B.Sc.', 'jobs': 8, 'higher': 6, 'govt': 4},
        {'course': 'B.Tech', 'jobs': 10, 'higher': 7, 'govt': 5},
      ],
      'Commerce': [
        {'course': 'B.Com.', 'jobs': 9, 'higher': 6, 'govt': 5},
        {'course': 'C.A.', 'jobs': 12, 'higher': 8, 'govt': 6},
      ],
      'Vocational': [
        {'course': 'Diploma', 'jobs': 15, 'higher': 5, 'govt': 2},
        {'course': 'B.Voc', 'jobs': 10, 'higher': 3, 'govt': 1},
      ],
    };

    final streamData = data[stream]!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildInfoCard(context),
          const SizedBox(height: 20),
          _buildCareerChart(context, streamData),
          const SizedBox(height: 20),
          _buildCareerPaths(context, stream),
          const SizedBox(height: 20),
          _buildCollegesButton(context, stream),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Understanding the $stream Stream',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'This section provides an overview of major courses, career opportunities, and potential for higher studies and government jobs in $stream.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCareerChart(
    BuildContext context,
    List<Map<String, Object>> streamData,
  ) {
    final barGroups = streamData.asMap().entries.map((entry) {
      final index = entry.key;
      final course = entry.value;
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: (course['jobs'] as int).toDouble(),
            color: Colors.blue.shade300,
            width: 15,
            borderRadius: BorderRadius.circular(5),
          ),
          BarChartRodData(
            toY: (course['higher'] as int).toDouble(),
            color: Colors.orange.shade300,
            width: 15,
            borderRadius: BorderRadius.circular(5),
          ),
          BarChartRodData(
            toY: (course['govt'] as int).toDouble(),
            color: Colors.green.shade300,
            width: 15,
            borderRadius: BorderRadius.circular(5),
          ),
        ],
      );
    }).toList();

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Career Opportunities Chart',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  barGroups: barGroups,
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          final courseName =
                              streamData[value.toInt()]['course'] as String;
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              courseName,
                              style: const TextStyle(fontSize: 12),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        interval: 2,
                        getTitlesWidget: (value, meta) => Text(
                          value.toInt().toString(),
                          style: const TextStyle(fontSize: 10),
                        ),
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: const FlGridData(show: false),
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final label = [
                          'Jobs',
                          'Higher Studies',
                          'Govt. Exams',
                        ][rodIndex];
                        return BarTooltipItem(
                          '$label: ${rod.toY.toInt()}',
                          const TextStyle(color: Colors.white),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              children: [
                _buildLegend(Colors.blue.shade300, 'Jobs'),
                _buildLegend(Colors.orange.shade300, 'Higher Studies'),
                _buildLegend(Colors.green.shade300, 'Govt. Exams'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildCareerPaths(BuildContext context, String stream) {
    final paths = {
      'Arts': {
        'jobs': [
          'Journalist',
          'Graphic Designer',
          'Content Writer',
          'Human Resources',
        ],
        'higher': ['M.A.', 'M.F.A.', 'Ph.D.'],
        'govt': ['UPSC', 'SSC CGL', 'State PSC'],
      },
      'Science': {
        'jobs': ['Software Engineer', 'Scientist', 'Doctor', 'Data Analyst'],
        'higher': ['M.S.', 'M.Tech', 'Ph.D.', 'M.D.'],
        'govt': ['IAS', 'ISRO', 'DRDO', 'Indian Forest Service'],
      },
      'Commerce': {
        'jobs': [
          'Financial Analyst',
          'Accountant',
          'Marketing Manager',
          'Auditor',
        ],
        'higher': ['M.Com.', 'MBA', 'CFA'],
        'govt': ['Bank PO', 'RBI Grade B', 'Income Tax Officer'],
      },
      'Vocational': {
        'jobs': [
          'Electrician',
          'Web Developer',
          'Chef',
          'Automobile Technician',
        ],
        'higher': ['B.Voc (advanced)', 'M.Voc'],
        'govt': ['Railway Jobs', 'Defence Services', 'Police'],
      },
    };

    final streamPaths = paths[stream]!;

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Detailed Career Paths',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildPathSection(
              context,
              'Common Job Roles',
              streamPaths['jobs']!,
            ),
            _buildPathSection(
              context,
              'Higher Studies',
              streamPaths['higher']!,
            ),
            _buildPathSection(
              context,
              'Government Exams',
              streamPaths['govt']!,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPathSection(
    BuildContext context,
    String title,
    List<String> items,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: items
                .map(
                  (item) => Chip(
                    label: Text(item),
                    backgroundColor: Colors.indigo.shade50,
                    labelStyle: TextStyle(color: Colors.indigo.shade800),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCollegesButton(BuildContext context, String stream) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CollegesListScreen(stream: stream),
            ),
          );
        },
        icon: const Icon(Icons.school),
        label: Text('Check $stream Colleges'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}
