import 'package:flutter/material.dart';
import 'package:projectx/chatbot_screen.dart';
import 'package:projectx/roadmap_screen.dart';
import 'package:projectx/userdashboard_screen.dart';
import 'package:provider/provider.dart';
import 'auth_service.dart';
import 'expert_advice_page.dart';
import 'alumni_advice_page.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // false for day mode, true for night mode
  bool _isNightMode = true;

  void _toggleTheme() {
    setState(() {
      _isNightMode = !_isNightMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    // Day (Blue & White) Theme
    const dayPrimaryColor = Color(0xFF1976D2);
    const dayBackgroundColor = Color(0xFFF5F5F5);
    const dayCardColor = Colors.white;

    // Night (Green & Black) Theme
    const nightPrimaryColor = Color(0xFF2E7D32); // Darker green
    const nightBackgroundColor = Colors.black;
    const nightCardColor = Color(0xFF1E1E1E); // Very dark gray

    // Determine current theme colors
    final primaryColor = _isNightMode ? nightPrimaryColor : dayPrimaryColor;
    final backgroundColor = _isNightMode
        ? nightBackgroundColor
        : dayBackgroundColor;
    final cardColor = _isNightMode ? nightCardColor : dayCardColor;
    final onCardColor = _isNightMode ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          'Dashboard',
          style: TextStyle(
            color: _isNightMode ? Colors.white : dayCardColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              _isNightMode ? Icons.light_mode : Icons.dark_mode,
              color: _isNightMode ? Colors.white : dayCardColor,
            ),
            onPressed: _toggleTheme,
          ),
          IconButton(
            icon: Icon(
              Icons.logout,
              color: _isNightMode ? Colors.white : dayCardColor,
            ),
            onPressed: () async {
              await authService.signOut();
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil('/auth', (route) => false);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
          children: [
            _buildGridButton(
              context,
              icon: Icons.person_outline,
              label: 'Profile',
              cardColor: cardColor,
              onCardColor: onCardColor,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const UserDashboardScreen(),
                  ),
                );
              },
            ),
            _buildGridButton(
              context,
              icon: Icons.lightbulb_outline,
              label: 'Quiz',
              cardColor: cardColor,
              onCardColor: onCardColor,
              onTap: () {
                Navigator.of(context).pushNamed('/quiz');
              },
            ),
            _buildGridButton(
              context,
              icon: Icons.chat_bubble_outline,
              label: 'Companion',
              cardColor: cardColor,
              onCardColor: onCardColor,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ChatBotScreen()),
                );
              },
            ),
            _buildGridButton(
              context,
              icon: Icons.map_outlined,
              label: 'Roadmap',
              cardColor: cardColor,
              onCardColor: onCardColor,
              onTap: () {
                Navigator.push(
                  context,
                  // The fix is here:
                  MaterialPageRoute(builder: (_) => const RoadmapScreen()),
                );
              },
            ),
            _buildGridButton(
              context,
              icon: Icons.school_outlined,
              label: 'Expert Advice',
              cardColor: cardColor,
              onCardColor: onCardColor,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ExpertAdvicePage(isNightMode: !_isNightMode),
                  ),
                );
              },
            ),
            _buildGridButton(
              context,
              icon: Icons.group_outlined,
              label: 'Alumini Advice',
              cardColor: cardColor,
              onCardColor: onCardColor,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AlumniAdvicePage(isNightMode: !_isNightMode),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color cardColor,
    required Color onCardColor,
    required VoidCallback onTap,
  }) {
    // Determine gradient based on theme
    final gradient = _isNightMode
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

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: gradient,
            boxShadow: [
              BoxShadow(
                color: onCardColor.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: onCardColor, size: 48),
              const SizedBox(height: 12),
              Text(
                label,
                style: TextStyle(
                  color: onCardColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
