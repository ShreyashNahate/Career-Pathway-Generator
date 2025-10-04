import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Question {
  final String text;
  final List<String> options;
  final List<Map<String, double>>
  scores; // { 'Arts': 0.5, 'Science': 0.1, ... }

  Question({required this.text, required this.options, required this.scores});
}

class QuizService with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final List<Question> _questions = [
    Question(
      text: 'Which subject do you enjoy studying the most?',
      options: [
        'Art and History',
        'Math and Physics',
        'Economics and Business',
        'Mechanics and Computers',
      ],
      scores: [
        {'Arts': 1.0, 'Science': 0.2, 'Commerce': 0.2, 'Vocational': 0.2},
        {'Arts': 0.2, 'Science': 1.0, 'Commerce': 0.2, 'Vocational': 0.2},
        {'Arts': 0.2, 'Science': 0.2, 'Commerce': 1.0, 'Vocational': 0.2},
        {'Arts': 0.2, 'Science': 0.2, 'Commerce': 0.2, 'Vocational': 1.0},
      ],
    ),
    Question(
      text: 'What kind of projects interest you the most?',
      options: [
        'Creative writing or painting',
        'Building a robot or a circuit',
        'Managing a mock business',
        'Repairing or building something practical',
      ],
      scores: [
        {'Arts': 1.0, 'Science': 0.2, 'Commerce': 0.2, 'Vocational': 0.2},
        {'Arts': 0.2, 'Science': 1.0, 'Commerce': 0.2, 'Vocational': 0.2},
        {'Arts': 0.2, 'Science': 0.2, 'Commerce': 1.0, 'Vocational': 0.2},
        {'Arts': 0.2, 'Science': 0.2, 'Commerce': 0.2, 'Vocational': 1.0},
      ],
    ),
    Question(
      text: 'How do you prefer to solve problems?',
      options: [
        'Through discussion and empathy',
        'Using logical and analytical thinking',
        'By strategizing and planning',
        'With hands-on experimentation',
      ],
      scores: [
        {'Arts': 1.0, 'Science': 0.2, 'Commerce': 0.2, 'Vocational': 0.2},
        {'Arts': 0.2, 'Science': 1.0, 'Commerce': 0.2, 'Vocational': 0.2},
        {'Arts': 0.2, 'Science': 0.2, 'Commerce': 1.0, 'Vocational': 0.2},
        {'Arts': 0.2, 'Science': 0.2, 'Commerce': 0.2, 'Vocational': 1.0},
      ],
    ),
    Question(
      text: 'What do you value most in a job?',
      options: [
        'Creativity and self-expression',
        'Discovery and innovation',
        'Financial success and stability',
        'Practical skills and direct impact',
      ],
      scores: [
        {'Arts': 1.0, 'Science': 0.2, 'Commerce': 0.2, 'Vocational': 0.2},
        {'Arts': 0.2, 'Science': 1.0, 'Commerce': 0.2, 'Vocational': 0.2},
        {'Arts': 0.2, 'Science': 0.2, 'Commerce': 1.0, 'Vocational': 0.2},
        {'Arts': 0.2, 'Science': 0.2, 'Commerce': 0.2, 'Vocational': 1.0},
      ],
    ),
    Question(
      text: 'Which type of book would you read?',
      options: [
        'A classic novel or a biography',
        'A book about technology or nature',
        'A book on personal finance or marketing',
        'A how-to guide for a specific skill',
      ],
      scores: [
        {'Arts': 1.0, 'Science': 0.2, 'Commerce': 0.2, 'Vocational': 0.2},
        {'Arts': 0.2, 'Science': 1.0, 'Commerce': 0.2, 'Vocational': 0.2},
        {'Arts': 0.2, 'Science': 0.2, 'Commerce': 1.0, 'Vocational': 0.2},
        {'Arts': 0.2, 'Science': 0.2, 'Commerce': 0.2, 'Vocational': 1.0},
      ],
    ),
    Question(
      text: 'What subject would you choose for a school project?',
      options: [
        'Writing a play or short story',
        'Conducting a science experiment',
        'Creating a business plan',
        'Building a birdhouse or a simple machine',
      ],
      scores: [
        {'Arts': 1.0, 'Science': 0.2, 'Commerce': 0.2, 'Vocational': 0.2},
        {'Arts': 0.2, 'Science': 1.0, 'Commerce': 0.2, 'Vocational': 0.2},
        {'Arts': 0.2, 'Science': 0.2, 'Commerce': 1.0, 'Vocational': 0.2},
        {'Arts': 0.2, 'Science': 0.2, 'Commerce': 0.2, 'Vocational': 1.0},
      ],
    ),
    Question(
      text: 'What hobby would you pick up?',
      options: [
        'Playing a musical instrument',
        'Coding or learning about space',
        'Stock market analysis',
        'Woodworking or cooking',
      ],
      scores: [
        {'Arts': 1.0, 'Science': 0.2, 'Commerce': 0.2, 'Vocational': 0.2},
        {'Arts': 0.2, 'Science': 1.0, 'Commerce': 0.2, 'Vocational': 0.2},
        {'Arts': 0.2, 'Science': 0.2, 'Commerce': 1.0, 'Vocational': 0.2},
        {'Arts': 0.2, 'Science': 0.2, 'Commerce': 0.2, 'Vocational': 1.0},
      ],
    ),
    Question(
      text: 'What do you find most interesting?',
      options: [
        'Human cultures and emotions',
        'How things work and are structured',
        'Money and how it flows',
        'Creating things with your hands',
      ],
      scores: [
        {'Arts': 1.0, 'Science': 0.2, 'Commerce': 0.2, 'Vocational': 0.2},
        {'Arts': 0.2, 'Science': 1.0, 'Commerce': 0.2, 'Vocational': 0.2},
        {'Arts': 0.2, 'Science': 0.2, 'Commerce': 1.0, 'Vocational': 0.2},
        {'Arts': 0.2, 'Science': 0.2, 'Commerce': 0.2, 'Vocational': 1.0},
      ],
    ),
    Question(
      text: 'What would be your ideal school subject?',
      options: [
        'Creative Writing',
        'Computer Science',
        'Accounting',
        'Automotive Repair',
      ],
      scores: [
        {'Arts': 1.0, 'Science': 0.2, 'Commerce': 0.2, 'Vocational': 0.2},
        {'Arts': 0.2, 'Science': 1.0, 'Commerce': 0.2, 'Vocational': 0.2},
        {'Arts': 0.2, 'Science': 0.2, 'Commerce': 1.0, 'Vocational': 0.2},
        {'Arts': 0.2, 'Science': 0.2, 'Commerce': 0.2, 'Vocational': 1.0},
      ],
    ),
    Question(
      text: 'How do you learn a new skill?',
      options: [
        'By reading and discussing the theory',
        'By conducting experiments',
        'By analyzing successful examples',
        'By practicing hands-on',
      ],
      scores: [
        {'Arts': 1.0, 'Science': 0.2, 'Commerce': 0.2, 'Vocational': 0.2},
        {'Arts': 0.2, 'Science': 1.0, 'Commerce': 0.2, 'Vocational': 0.2},
        {'Arts': 0.2, 'Science': 0.2, 'Commerce': 1.0, 'Vocational': 0.2},
        {'Arts': 0.2, 'Science': 0.2, 'Commerce': 0.2, 'Vocational': 1.0},
      ],
    ),
  ];

  final Map<String, double> _scores = {
    'Arts': 0.0,
    'Science': 0.0,
    'Commerce': 0.0,
    'Vocational': 0.0,
  };

  int _currentQuestionIndex = 0;
  String _recommendedStream = '';

  List<Question> get questions => _questions;
  int get currentQuestionIndex => _currentQuestionIndex;
  String get recommendedStream => _recommendedStream;

  void answerQuestion(int optionIndex) {
    if (_currentQuestionIndex < _questions.length) {
      final scores = _questions[_currentQuestionIndex].scores[optionIndex];
      scores.forEach((key, value) {
        _scores[key] = (_scores[key] ?? 0) + value;
      });
      _currentQuestionIndex++;
      notifyListeners();
      print('Current scores: $_scores');
    }
  }

  void calculateResult() {
    _recommendedStream = _scores.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
    print('Recommended Stream: $_recommendedStream');
    notifyListeners();
  }

  Future<void> saveResult() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      print('User not authenticated. Cannot save quiz results.');
      return;
    }

    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('quiz_results')
          .add({
            'timestamp': FieldValue.serverTimestamp(),
            'scores': _scores,
            'recommended_stream': _recommendedStream,
          });
      print('Quiz results saved successfully for UID: $uid');
    } catch (e) {
      print('Error saving quiz results: $e');
    }
  }

  void resetQuiz() {
    _currentQuestionIndex = 0;
    _scores.updateAll((key, value) => 0.0);
    _recommendedStream = '';
    notifyListeners();
  }
}
