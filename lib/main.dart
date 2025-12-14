import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'providers/gold_price_provider.dart';
import 'screens/gold_calculator_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GoldPriceProvider()),
      ],
      child: MaterialApp(
        title: 'الصايغ',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // Modern iOS-inspired theme with white background
          brightness: Brightness.light,
          primarySwatch: Colors.blue,
          primaryColor: const Color(0xFF007AFF),
          scaffoldBackgroundColor: const Color(0xFFF2F2F7),
          
          // App Bar Theme - Modern iOS Style
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
            centerTitle: true,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            titleTextStyle: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Colors.black,
              letterSpacing: -0.5,
            ),
            iconTheme: IconThemeData(
              color: Colors.black,
              size: 24,
            ),
          ),
          
          // Card Theme - Modern iOS Cards
          cardTheme: CardThemeData(
            color: Colors.white,
            elevation: 0,
            shadowColor: Colors.black.withValues(alpha: 0.04),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: Colors.black.withValues(alpha: 0.04),
                width: 0.5,
              ),
            ),
          ),
          
          // Elevated Button Theme - iOS Style
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF007AFF),
              foregroundColor: Colors.white,
              elevation: 0,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              textStyle: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w400,
                letterSpacing: -0.5,
              ),
            ),
          ),
          
          // Input Decoration Theme - Modern iOS Style
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: const Color(0xFFF2F2F7),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xFF007AFF),
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xFFFF3B30),
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            hintStyle: TextStyle(
              color: Colors.black.withValues(alpha: 0.3),
              fontSize: 17,
            ),
            labelStyle: TextStyle(
              color: Colors.black.withValues(alpha: 0.6),
              fontSize: 17,
            ),
          ),
          
          // Text Theme - Modern Typography
          textTheme: const TextTheme(
            displayLarge: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w400,
              color: Colors.black,
              letterSpacing: -0.5,
            ),
            displayMedium: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w400,
              color: Colors.black,
              letterSpacing: -0.5,
            ),
            displaySmall: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w400,
              color: Colors.black,
              letterSpacing: -0.5,
            ),
            headlineLarge: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w400,
              color: Colors.black,
              letterSpacing: -0.5,
            ),
            headlineMedium: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: Colors.black,
              letterSpacing: -0.5,
            ),
            headlineSmall: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: Colors.black,
              letterSpacing: -0.5,
            ),
            titleLarge: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Colors.black,
              letterSpacing: -0.5,
            ),
            titleMedium: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.black,
              letterSpacing: -0.5,
            ),
            titleSmall: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: Colors.black,
              letterSpacing: 0,
            ),
            bodyLarge: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w400,
              color: Colors.black,
              letterSpacing: -0.5,
            ),
            bodyMedium: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.black,
              letterSpacing: -0.5,
            ),
            bodySmall: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: Colors.black,
              letterSpacing: 0,
            ),
            labelLarge: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w400,
              color: Colors.black,
              letterSpacing: -0.5,
            ),
            labelMedium: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.black,
              letterSpacing: -0.5,
            ),
            labelSmall: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: Colors.black,
              letterSpacing: 0,
            ),
          ),
          
          // Color Scheme - Modern iOS Colors
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF007AFF),
            secondary: Color(0xFF5856D6),
            surface: Colors.white,
            error: Color(0xFFFF3B30),
            onPrimary: Colors.white,
            onSecondary: Colors.white,
            onSurface: Colors.black,
            onError: Colors.white,
          )
        ),
        home: const GoldCalculatorScreen(),
      ),
    );
  }
}
