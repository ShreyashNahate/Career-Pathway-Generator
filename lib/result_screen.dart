import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'quiz_service.dart';
import 'auth_service.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final quizService = Provider.of<QuizService>(context);
    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Result'),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            quizService.resetQuiz();
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildResultCard(context, quizService.recommendedStream),
              const SizedBox(height: 48),
              _buildActionButton(
                context,
                label: 'Retake Quiz',
                icon: Icons.refresh,
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  quizService.resetQuiz();
                  Navigator.of(context).pop();
                },
              ),
              const SizedBox(height: 16),
              _buildActionButton(
                context,
                label: 'View Career Paths',
                icon: Icons.school,
                color: Colors.indigo,
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/career',
                    arguments: quizService.recommendedStream,
                  );
                },
              ),
              const SizedBox(height: 16),
              _buildActionButton(
                context,
                label: 'Sign Out',
                icon: Icons.logout,
                color: Colors.redAccent,
                onPressed: () async {
                  await authService.signOut();
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard(BuildContext context, String stream) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOut,
      padding: const EdgeInsets.all(32.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF4C51BF), Color(0xFF2B6CB0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(Icons.star, size: 60, color: Colors.amber),
          const SizedBox(height: 16),
          Text(
            'Based on your answers,\nyour recommended stream is:',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Text(
            stream,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.yellowAccent,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 5,
      ),
    );
  }
}
