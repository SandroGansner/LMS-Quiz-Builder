import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lms_quiz_tool/quiz_screen.dart';
import 'package:lms_quiz_tool/admin_dashboard.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LMS Quiz Tool',
      theme: ThemeData(primarySwatch: Colors.red),
      initialRoute: '/',
      routes: {
        '/': (context) => const AdminDashboard(),
        '/quiz': (context) => const QuizScreen(),
      },
    );
  }
}
