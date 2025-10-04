// alumni_advice_page.dart
import 'package:flutter/material.dart';

class AlumniAdvicePage extends StatefulWidget {
  final bool isNightMode;
  const AlumniAdvicePage({super.key, required this.isNightMode});

  @override
  State<AlumniAdvicePage> createState() => _AlumniAdvicePageState();
}

class _AlumniAdvicePageState extends State<AlumniAdvicePage> {
  final List<Map<String, String>> allAlumni = [
    {
      'name': 'Rohit Mehra',
      'college': 'IIT Delhi',
      'passYear': '2015',
      'qualification': 'B.Tech Computer Science',
      'post': 'Software Engineer at Google',
    },
    {
      'name': 'Ananya Singh',
      'college': 'Delhi University',
      'passYear': '2018',
      'qualification': 'B.A Economics',
      'post': 'Analyst at Goldman Sachs',
    },
    {
      'name': 'Vikram Patel',
      'college': 'BITS Pilani',
      'passYear': '2016',
      'qualification': 'M.Tech Mechanical',
      'post': 'Project Manager at Tata Motors',
    },
    {
      'name': 'Priya Sharma',
      'college': 'Jamia Millia Islamia',
      'passYear': '2017',
      'qualification': 'MBA Marketing',
      'post': 'Marketing Lead at Flipkart',
    },
    {
      'name': 'Amit Joshi',
      'college': 'IIT Bombay',
      'passYear': '2014',
      'qualification': 'B.Tech Electrical',
      'post': 'CTO at a Startup',
    },
    {
      'name': 'Sonal Verma',
      'college': 'Delhi University',
      'passYear': '2019',
      'qualification': 'B.Sc Computer Science',
      'post': 'Data Analyst at Microsoft',
    },
    {
      'name': 'Karan Gupta',
      'college': 'VIT Vellore',
      'passYear': '2016',
      'qualification': 'B.Tech Civil',
      'post': 'Civil Engineer at L&T',
    },
    {
      'name': 'Ritika Rao',
      'college': 'IIT Madras',
      'passYear': '2015',
      'qualification': 'M.Tech AI',
      'post': 'AI Specialist at Amazon',
    },
  ];

  List<Map<String, String>> displayedAlumni = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    displayedAlumni = List.from(allAlumni);
  }

  void searchAlumni(String query) {
    final filtered = allAlumni.where((alum) {
      final qualification = alum['qualification']!.toLowerCase();
      return qualification.contains(query.toLowerCase());
    }).toList();

    setState(() {
      displayedAlumni = filtered;
    });
  }

  void showConnectPopup(String name) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          'Connect with $name',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'You will receive a call soon.',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'OK',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = widget.isNightMode
        ? Colors.black
        : const Color(0xFFF5F5F5);
    final gradient = widget.isNightMode
        ? const LinearGradient(
            colors: [Color(0xFF2E7D32), Color(0xFF43A047)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        : const LinearGradient(
            colors: [Color(0xFF1976D2), Color(0xFF2196F3)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );
    final onCardColor = Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Alumni Advice'),
        backgroundColor: widget.isNightMode
            ? const Color(0xFF2E7D32)
            : const Color(0xFF1976D2),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: searchController,
              onChanged: searchAlumni,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                hintText: 'Search by qualification',
                hintStyle: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                ),
                filled: true,
                fillColor: widget.isNightMode
                    ? Colors.grey[800]
                    : const Color.fromARGB(255, 6, 32, 53),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.white),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: displayedAlumni.length,
              itemBuilder: (context, index) {
                final alum = displayedAlumni[index];
                return Card(
                  elevation: 6,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: gradient,
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          alum['name']!,
                          style: TextStyle(
                            color: onCardColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'College: ${alum['college']}',
                          style: TextStyle(
                            color: onCardColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Passing Year: ${alum['passYear']}',
                          style: TextStyle(
                            color: onCardColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Qualification: ${alum['qualification']}',
                          style: TextStyle(
                            color: onCardColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Current Post: ${alum['post']}',
                          style: TextStyle(
                            color: onCardColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () => showConnectPopup(alum['name']!),
                            child: const Text(
                              'Connect',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
