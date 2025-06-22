import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'pages/login_page.dart';
import 'pages/doctor_who_wiki.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBGrhmGVaKBnTMChqk1hRCqnrIm2b9-p_U",
      authDomain: "doctor-8f2d1.firebaseapp.com",
      projectId: "doctor-8f2d1",
      storageBucket: "doctor-8f2d1.firebasestorage.app",
      messagingSenderId: "569307263229",
      appId: "1:569307263229:web:48e00260d820cc18e94e94",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
