import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/ahp_provider.dart';
import 'screens/home_page.dart';
import 'screens/comparison_page.dart';
import 'screens/result_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AhpProvider()),
      ],
      child: MaterialApp(
        title: 'Agro-AHP Pro',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF2E7D32), // Jungle Green
            primary: const Color(0xFF2E7D32),
            secondary: const Color(0xFF81C784),
            tertiary: const Color(0xFF1B5E20),
            surface: const Color(0xFFF1F8E9),
            background: const Color(0xFFF1F8E9),
          ),
          scaffoldBackgroundColor: const Color(0xFFF1F8E9),
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.transparent, // Transparent for gradient background
            foregroundColor: Colors.white,
            titleTextStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          cardTheme: CardThemeData(
            elevation: 8,
            shadowColor: Colors.black26,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            color: Colors.white.withOpacity(0.9), // Glassmorphism base
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 32),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              elevation: 5,
              shadowColor: Colors.green.withOpacity(0.4),
            ),
          ),
          sliderTheme: SliderThemeData(
            activeTrackColor: const Color(0xFF43A047),
            inactiveTrackColor: Colors.green.withOpacity(0.2),
            thumbColor: const Color(0xFF1B5E20),
            overlayColor: const Color(0xFF2E7D32).withOpacity(0.2),
            trackHeight: 12, // Thicker track
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 14.0),
            trackShape: const RoundedRectSliderTrackShape(),
          ),
          fontFamily: 'Roboto', // Default flutter font but let's stick to it for safety
        ),
        home: const HomePage(),
        routes: {
          '/comparison': (context) => const ComparisonPage(),
          '/result': (context) => const ResultPage(),
        },
      ),
    );
  }
}
