import 'package:flutter/material.dart';

class SearchRidesScreen extends StatelessWidget {
  const SearchRidesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Pretraži vožnje',
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}