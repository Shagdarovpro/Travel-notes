import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/travel_provider.dart';
import 'ui/screens/home_screen.dart';

class TravelNotesApp extends StatelessWidget {
  const TravelNotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TravelProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'TravelNotes',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
