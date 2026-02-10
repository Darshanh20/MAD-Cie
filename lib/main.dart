import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'routes/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Supabase
    await Supabase.initialize(
      url: 'https://lmxpykolgesjxkyruswi.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxteHB5a29sZ2VzanhreXJ1c3dpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzQ0MzUwMTcsImV4cCI6MjA1MDAxMTAxN30.6pGZ4ZhY6NivOctk4V-RCfT-TZ6N4FqJ6wAGl5w59VI',
    );
    print('✅ Supabase initialized successfully');

    print('✅ Supabase service ready to use');
  } catch (e) {
    print('❌ Error during initialization: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CIE Exam',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.login,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
