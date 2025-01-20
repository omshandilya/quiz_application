// quiz_screen.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'result_page.dart';
import 'dart:async';

class QuizScreen extends StatefulWidget {
  const QuizScreen({Key? key}) : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List _questions = [];
  int _currentIndex = 0;
  int _score = 0;
  int? _selectedOption;
  int _timeLeft = 15; // Timer duration in seconds
  Timer? _timer;

  bool _showFeedbackScreen = false;
  bool _isCorrectAnswer = false;
  bool _earnedBonus = false;

  @override
  void initState() {
    super.initState();
    fetchQuizData();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> fetchQuizData() async {
    try {
      final response = await http.get(
          Uri.parse('https://api.jsonserve.com/Uw5CrX'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _questions = data['questions'] ??
              []; // Default to an empty list if 'questions' is null
        });
        startTimer();
      } else {
        throw Exception('Failed to load quiz data');
      }
    } catch (e) {
      print('Error fetching data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Failed to load quiz data. Please try again later.')),
      );
    }
  }

  void startTimer() {
    _timer?.cancel();
    setState(() {
      _timeLeft = 15;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
      } else {
        timer.cancel();
        _nextQuestion();
      }
    });
  }

  void _nextQuestion() {
    _timer?.cancel();

    if (_selectedOption != null) {
      final selectedAnswer = _questions[_currentIndex]['options'][_selectedOption!];
      final isCorrect = selectedAnswer['is_correct'] == true;

      setState(() {
        _isCorrectAnswer = isCorrect;
        _earnedBonus = isCorrect && _timeLeft > 10;

        if (isCorrect) {
          _score += 1;
          if (_earnedBonus) _score += 5; // Extra points for fast answer
        }

        _showFeedbackScreen = true;
      });

      // Show feedback screen for 4 seconds, then move to the next question or submit
      Future.delayed(const Duration(seconds: 4), () {
        setState(() {
          _showFeedbackScreen = false;

          if (_currentIndex < _questions.length - 1) {
            _currentIndex++;
            _selectedOption = null;
            startTimer();
          } else {
            _submitQuiz();
          }
        });
      });
    }
  }

  void _submitQuiz() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ResultPage(score: _score, totalQuestions: _questions.length),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz App')),
      body: _questions.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : _showFeedbackScreen
          ? _buildFeedbackScreen()
          : buildQuestion(),
    );
  }

  Widget _buildFeedbackScreen() {
    return Container(
      color: _isCorrectAnswer ? Colors.green : Colors.red,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _isCorrectAnswer ? 'Correct!' : 'Wrong!',
              style: const TextStyle(fontSize: 32,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            if (_earnedBonus)
              const SizedBox(height: 20),
            if (_earnedBonus)
              const Text(
                'You earned 5 extra points for answering quickly!',
                style: TextStyle(fontSize: 20, color: Colors.white),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }

  Widget buildQuestion() {
    final question = _questions[_currentIndex];
    final questionText = question['description'] ?? 'No question available';
    final answers = question['options'] ?? [];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Time Left: $_timeLeft s',
            style: const TextStyle(fontSize: 18, color: Colors.cyan),
          ),
          const SizedBox(height: 10),
          Text(
            questionText,
            style: const TextStyle(fontSize: 24),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: answers
                  .asMap()
                  .entries
                  .map<Widget>((entry) {
                final index = entry.key;
                final answer = entry.value;
                final answerText = answer['description'] ??
                    'No answer available';
                final isSelected = _selectedOption == index;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSelected ? Colors.blueAccent : null,
                    ),
                    onPressed: () {
                      setState(() {
                        _selectedOption = index;
                      });
                    },
                    child: Text(answerText),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: _nextQuestion,
                child: Text(
                    _currentIndex == _questions.length - 1 ? 'Submit' : 'Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}





