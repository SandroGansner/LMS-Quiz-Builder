# LMS Quiz Tool (Flutter)

This directory contains a minimal Flutter application that works with Firebase to build interactive quizzes for the **Lenzerheide** and **Bike Kingdom** brands.

## Features

- Brand-specific quiz screen with dynamic colors and logos
- Fade-in animations and progress bar
- Social sharing button
- Admin dashboard (web) for creating quizzes and generating embed codes
- Firebase Firestore storage and Firebase Authentication

## Firebase Setup

1. Create a Firebase project.
2. Enable **Authentication** (e.g. Email/Password) and set up rules with admin roles.
3. Enable **Firestore** database and secure access via rules.
4. Use `flutterfire configure` to generate `lib/firebase_options.dart` and update this file.
5. Deploy the web build to Firebase Hosting if you want to host the embedded quiz under `https://quiz.lms-ag.ch`.

Firestore document structure:
```json
{
  "quiz_id": "uuid",
  "title": "string",
  "brand": "Lenzerheide/Bike Kingdom",
  "questions": [
    {"id": 1, "text": "string", "options": ["string"], "correct_answer": null}
  ],
  "embed_code": "<iframe src='https://quiz.lms-ag.ch/embed/quiz_id' width='100%' height='600px' frameborder='0'></iframe>",
  "created_at": "timestamp"
}
```

## Running

```
flutter pub get
flutter run -d chrome
```

Use VS Code with the Flutter extension for best experience.
