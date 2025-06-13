import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';

enum Brand { lenzerheide, bikeKingdom }

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen>
    with SingleTickerProviderStateMixin {
  int _currentQuestion = 0;
  List<Map<String, dynamic>> _questions = [];
  Brand? _brand;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _loadQuiz();
  }

  Future<void> _loadQuiz() async {
    // Example: fetch quiz from Firestore
    final quizId = const Uuid().v4(); // Replace with real ID from navigation
    final doc = await FirebaseFirestore.instance.collection('quizzes').doc(quizId).get();
    if (doc.exists) {
      setState(() {
        _brand = doc['brand'] == 'Bike Kingdom' ? Brand.bikeKingdom : Brand.lenzerheide;
        _questions = List<Map<String, dynamic>>.from(doc['questions']);
      });
    }
  }

  void _nextQuestion() {
    if (_currentQuestion < _questions.length - 1) {
      setState(() => _currentQuestion++);
      _controller.forward(from: 0);
    }
  }

  Color get backgroundColor =>
      _brand == Brand.bikeKingdom ? Colors.black : const Color(0xFFD32F2F);

  String get logoAsset => _brand == Brand.bikeKingdom
      ? 'assets/bikekingdom_logo.png'
      : 'assets/lenzerheide_logo.png';

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final question = _questions[_currentQuestion];
    final progress = (_currentQuestion + 1) / _questions.length;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        centerTitle: true,
        title: Image.asset(logoAsset, height: 40),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LinearProgressIndicator(value: progress, color: Colors.white),
            const SizedBox(height: 16),
            FadeTransition(
              opacity: _controller.drive(CurveTween(curve: Curves.easeIn)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    question['text'] ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...List.generate(
                    question['options'].length,
                    (index) => Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black, width: 2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: ListTile(
                        title: Text(
                          question['options'][index],
                          style: const TextStyle(color: Colors.black),
                        ),
                        onTap: _nextQuestion,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  color: Colors.white,
                  icon: const Icon(Icons.share),
                  onPressed: () {
                    Share.share('Ich mache gerade ein Quiz!');
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
