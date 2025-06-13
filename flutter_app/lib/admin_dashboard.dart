import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  String _brand = 'Lenzerheide';
  List<QuestionForm> _questions = [QuestionForm()];
  bool _saving = false;
  String? _embedCode;

  Future<void> _saveQuiz() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final quizId = const Uuid().v4();
    await FirebaseFirestore.instance.collection('quizzes').doc(quizId).set({
      'quiz_id': quizId,
      'title': _titleController.text,
      'brand': _brand,
      'questions': _questions
          .map((q) => {
                'id': q.id,
                'text': q.textController.text,
                'options': q.optionsController
                    .where((c) => c.text.isNotEmpty)
                    .map((c) => c.text)
                    .toList(),
                'correct_answer': null,
              })
          .toList(),
      'embed_code':
          "<iframe src='https://quiz.lms-ag.ch/embed/$quizId' width='100%' height='600px' frameborder='0'></iframe>",
      'created_at': FieldValue.serverTimestamp(),
    });

    setState(() {
      _embedCode =
          "<iframe src='https://quiz.lms-ag.ch/embed/$quizId' width='100%' height='600px' frameborder='0'></iframe>";
      _saving = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz Admin Dashboard')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Titel'),
                maxLength: 100,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Titel erforderlich' : null,
              ),
              DropdownButtonFormField<String>(
                value: _brand,
                decoration: const InputDecoration(labelText: 'Marke'),
                items: const [
                  DropdownMenuItem(value: 'Lenzerheide', child: Text('Lenzerheide')),
                  DropdownMenuItem(value: 'Bike Kingdom', child: Text('Bike Kingdom')),
                ],
                onChanged: (v) => setState(() => _brand = v ?? 'Lenzerheide'),
              ),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _questions.length,
                itemBuilder: (context, index) {
                  return _questions[index];
                },
              ),
              TextButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Frage hinzufügen'),
                onPressed: () => setState(() => _questions.add(QuestionForm())),
              ),
              const SizedBox(height: 24),
              _saving
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _saveQuiz,
                      child: const Text('Quiz speichern'),
                    ),
              if (_embedCode != null) ...[
                const SizedBox(height: 24),
                SelectableText('Embed Code:'),
                SelectableText(_embedCode!),
              ]
            ],
          ),
        ),
      ),
    );
  }
}

class QuestionForm extends StatefulWidget {
  final String id = const Uuid().v4();
  final TextEditingController textController = TextEditingController();
  final List<TextEditingController> optionsController =
      List.generate(4, (_) => TextEditingController());

  QuestionForm({super.key});

  @override
  State<QuestionForm> createState() => _QuestionFormState();
}

class _QuestionFormState extends State<QuestionForm> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: widget.textController,
              decoration: const InputDecoration(labelText: 'Fragetext'),
              maxLength: 200,
              validator: (v) =>
                  v == null || v.isEmpty ? 'Frage erforderlich' : null,
            ),
            const SizedBox(height: 8),
            ...List.generate(widget.optionsController.length, (index) {
              return TextFormField(
                controller: widget.optionsController[index],
                decoration: InputDecoration(labelText: 'Antwort ${index + 1}'),
                maxLength: 100,
              );
            }),
          ],
        ),
      ),
    );
  }
}
