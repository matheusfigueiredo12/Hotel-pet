import 'package:flutter/material.dart';

import 'screens/animal_list_screen.dart';

void main() {
  runApp(const HotelPetApp());
}

class HotelPetApp extends StatelessWidget {
  const HotelPetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hotel Pet',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.teal,
        useMaterial3: true,
      ),
      home: const AnimalListScreen(),
    );
  }
}
