import 'package:flutter/material.dart';
import 'package:ph2_pwm_hashfi/routers/route_pages.dart';
import 'package:ph2_pwm_hashfi/routers/routes_name.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://jobexwtviwqscwtaorvi.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpvYmV4d3R2aXdxc2N3dGFvcnZpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjgyNjI5MzMsImV4cCI6MjA0MzgzODkzM30.8d5FWnUjcf91W2od45E9iOz0ncTNAQGZc2FJwlWGOFA',
  );
  final isLoggedIn = await isUsernameNull();

  runApp(MyApp(initialRoute: isLoggedIn ? RoutesName.home : RoutesName.signUp));
}

final supabase = Supabase.instance.client;

Future<bool> isUsernameNull() async {
  final prefs = await SharedPreferences.getInstance();
  final username = prefs.getString('username');
  return username != null;
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    final route = RoutePages();
    return MaterialApp(
      title: 'PH2 Project Hashfi',
      theme: ThemeData(
        fontFamily: 'Helvetica',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: route.onRoute,
      initialRoute: initialRoute,
    );
  }
}
