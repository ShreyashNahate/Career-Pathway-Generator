// expert_advice_page.dart
import 'package:flutter/material.dart';

class ExpertAdvicePage extends StatefulWidget {
  final bool isNightMode;
  const ExpertAdvicePage({super.key, required this.isNightMode});

  @override
  State<ExpertAdvicePage> createState() => _ExpertAdvicePageState();
}

class _ExpertAdvicePageState extends State<ExpertAdvicePage> {
  final List<Map<String, String>> allExperts = [
    {
      'name': 'Dr. Anjali Sharma',
      'expertise': 'Software Engineering',
      'qualification': 'PhD in Computer Science',
      'fee': '₹500',
    },
    {
      'name': 'Mr. Rajesh Kumar',
      'expertise': 'Digital Marketing',
      'qualification': 'MBA Marketing',
      'fee': '₹400',
    },
    {
      'name': 'Ms. Priya Singh',
      'expertise': 'Career Counselling',
      'qualification': 'M.A Psychology',
      'fee': '₹350',
    },
    {
      'name': 'Dr. Vivek Mehta',
      'expertise': 'Data Science',
      'qualification': 'PhD in AI',
      'fee': '₹600',
    },
    {
      'name': 'Mrs. Sunita Rao',
      'expertise': 'Finance & Investment',
      'qualification': 'CFA, MBA Finance',
      'fee': '₹450',
    },
    {
      'name': 'Mr. Amit Joshi',
      'expertise': 'Entrepreneurship',
      'qualification': 'MBA, B.Tech',
      'fee': '₹500',
    },
    {
      'name': 'Ms. Ritu Verma',
      'expertise': 'UI/UX Design',
      'qualification': 'B.Des Graphic Design',
      'fee': '₹400',
    },
    {
      'name': 'Dr. Sandeep Gupta',
      'expertise': 'Blockchain Technology',
      'qualification': 'PhD in Computer Science',
      'fee': '₹650',
    },
  ];

  List<Map<String, String>> displayedExperts = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    displayedExperts = List.from(allExperts);
  }

  void searchExpert(String query) {
    final filtered = allExperts.where((expert) {
      final qualification = expert['qualification']!.toLowerCase();
      return qualification.contains(query.toLowerCase());
    }).toList();

    setState(() {
      displayedExperts = filtered;
    });
  }

  void showPaymentPopup(String name, String fee) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          'Payment for $name',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'You need to pay $fee to unlock $name.',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$name unlocked! Start your session.')),
              );
            },
            child: const Text(
              'Pay',
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
        title: const Text('Expert Advice'),
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
              onChanged: searchExpert,
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
              itemCount: displayedExperts.length,
              itemBuilder: (context, index) {
                final expert = displayedExperts[index];
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
                          expert['name']!,
                          style: TextStyle(
                            color: onCardColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Expertise: ${expert['expertise']}',
                          style: TextStyle(
                            color: onCardColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Qualification: ${expert['qualification']}',
                          style: TextStyle(
                            color: onCardColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Fee: ${expert['fee']}',
                          style: TextStyle(
                            color: onCardColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () => showPaymentPopup(
                              expert['name']!,
                              expert['fee']!,
                            ),
                            child: const Text(
                              'Unlock',
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
