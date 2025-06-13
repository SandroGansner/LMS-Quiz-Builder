# Firebase Configuration

This directory contains example configuration files for Firebase Hosting and Firestore security rules.

- `firebase.json` – Hosting configuration assuming the web build is placed in `build/web`.
- `firestore.rules` – Basic rules allowing anyone to read quizzes but only authenticated users with the `admin` custom claim to write.

Deploy using the Firebase CLI:

```
firebase deploy --only hosting,firestore
```
