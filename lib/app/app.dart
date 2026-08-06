import 'package:flutter/material.dart';

import 'theme.dart';
import '../features/welcome/presentation/welcome_screen.dart';

class Go2WorkApp extends StatelessWidget {
  const Go2WorkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Go2Work',
      theme: AppTheme.lightTheme,
      home: const WelcomeScreen(),
    );
  }
}