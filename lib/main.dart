import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:quiz_app/quiz_screen.dart';

import 'intro_page.dart';

void main() {
  runApp(const QuizApp());
}

class QuizApp extends StatelessWidget {
  const QuizApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Quiz App',
      theme: ThemeData.dark(),
      initialRoute: '/',
      routes: {
        '/': (context) => const IntroPage(),
        '/quiz': (context) => const QuizScreen(),
      },
    );
  }
}

