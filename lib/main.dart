import 'package:flutter/material.dart';
import 'package:ph2_pwm_hashfi/routers/route_pages.dart';
import 'package:ph2_pwm_hashfi/routers/routes_name.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: '',
    anonKey: '',
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
