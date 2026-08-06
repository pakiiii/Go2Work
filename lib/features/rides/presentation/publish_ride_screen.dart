import 'package:flutter/material.dart';

class PublishRideScreen extends StatelessWidget {
  const PublishRideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Objavi vožnju',
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}