import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vaiprasala/screens/tela_ensalamento.dart';
import 'screens/tela_login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://jlhrwonklbszqyskwjwt.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpsaHJ3b25rbGJzenF5c2t3and0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDUyNTQ3ODcsImV4cCI6MjA2MDgzMDc4N30.rt7Me5D4hzhGZHai8fn6H-khRv2cWV7LDOhrs8m__Es',
  );

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TelaEnsalamento(),
    );
  }
}
