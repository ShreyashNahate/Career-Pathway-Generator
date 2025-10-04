// colleges_list_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:url_launcher/url_launcher.dart';

class CollegesListScreen extends StatefulWidget {
  final String stream;

  const CollegesListScreen({Key? key, required this.stream}) : super(key: key);

  @override
  _CollegesListScreenState createState() => _CollegesListScreenState();
}

class _CollegesListScreenState extends State<CollegesListScreen> {
  final _database = FirebaseDatabase.instance.ref();
  late Future<List<Map<String, dynamic>>> _collegesFuture;

  @override
  void initState() {
    super.initState();
    _collegesFuture = _fetchCollegesByStream();
  }

  Future<List<Map<String, dynamic>>> _fetchCollegesByStream() async {
    try {
      final snapshot = await _database.child('colleges').get();

      if (!snapshot.exists || snapshot.value == null) {
        return [];
      }

      final collegesData = (snapshot.value as Map).values.toList();
      List<Map<String, dynamic>> colleges = [];

      for (var value in collegesData) {
        final Map<String, dynamic> college = Map<String, dynamic>.from(value);
        final List<dynamic> collegeStreams = college['stream'] ?? [];

        if (collegeStreams.contains(widget.stream)) {
          colleges.add(college);
        }
      }
      return colleges;
    } catch (e) {
      print('Error fetching colleges: $e');
      return Future.error(
        'Failed to load colleges. Please check your network and permissions.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.stream} Colleges',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue.shade800,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _collegesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No ${widget.stream} colleges found.'));
          }

          final colleges = snapshot.data!;
          return ListView.builder(
            itemCount: colleges.length,
            itemBuilder: (context, index) {
              final college = colleges[index];
              return CollegeCard(college: college);
            },
          );
        },
      ),
    );
  }
}

class CollegeCard extends StatelessWidget {
  final Map<String, dynamic> college;

  const CollegeCard({Key? key, required this.college}) : super(key: key);

  void _launchGoogleMaps() async {
    final lat = (college['location']['latitude'] as num).toDouble();
    final lon = (college['location']['longitude'] as num).toDouble();
    final name = college['name'];

    final uri = Uri.parse('geo:$lat,$lon?q=${Uri.encodeComponent(name)}');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }

  void _launchPhoneDialer() async {
    final contact = college['contact'] as String?;
    if (contact != null) {
      final Uri launchUri = Uri(scheme: 'tel', path: contact);
      await launchUrl(launchUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              college['name'],
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            if (college['ranking'] != null &&
                college['ranking']['overall'] != null)
              Text(
                'Overall Rank: ${college['ranking']['overall']}',
                style: GoogleFonts.poppins(color: Colors.grey[700]),
              ),
            if (college['ranking'] != null &&
                college['ranking'][college['stream']?.first.toLowerCase()] !=
                    null)
              Text(
                '${college['stream']?.first} Rank: ${college['ranking'][college['stream']?.first.toLowerCase()]}',
                style: GoogleFonts.poppins(color: Colors.grey[700]),
              ),
            const SizedBox(height: 8),
            Text(
              'Programs: ${(college['programs'] as List).join(', ')}',
              style: GoogleFonts.poppins(),
            ),
            const SizedBox(height: 4),
            Text(
              'Cut-offs: ${(college['cut_offs'] as Map).values.join(', ')}',
              style: GoogleFonts.poppins(),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: _launchGoogleMaps,
                  icon: const Icon(Icons.location_on, size: 18),
                  label: const Text('Locate on Map'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
                if (college['contact'] != null)
                  IconButton(
                    onPressed: _launchPhoneDialer,
                    icon: const Icon(Icons.phone),
                    color: Colors.blue.shade800,
                    tooltip: 'Call College',
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
