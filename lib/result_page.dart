import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  final int score;
  final int totalQuestions;

  const ResultPage({Key? key, required this.score, required this.totalQuestions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String feedbackMessage;
    String emoji;
    int maxScore = totalQuestions * 5; // Calculate maximum score

    // Determine feedback based on score
    if (score < maxScore * 0.5) { // Less than 50% of max score
      feedbackMessage = 'Improvement Needed';
      emoji = '😞';
    } else if (score <= maxScore * 0.7) { // Between 50% and 70% of max score
      feedbackMessage = 'Good Job!';
      emoji = '😊';
    } else { // More than 70% of max score
      feedbackMessage = 'Excellent Work!';
      emoji = '🎉';
    }

    return Scaffold(
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(16.0),
          elevation: 8.0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Quiz Completed!',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  emoji,
                  style: const TextStyle(fontSize: 50),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  feedbackMessage,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: Colors.blueAccent),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  'Your Score: $score / $maxScore',
                  style: const TextStyle(fontSize: 24),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/');
                  },
                  child: const Text('Restart Quiz', style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

