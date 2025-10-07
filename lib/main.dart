import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:web_flut/presentation/splash/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:web_flut/firebase_options.dart';

void main() async {
  // Set default locale into indonesian
  Intl.defaultLocale = 'id';
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Bookshelf',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
