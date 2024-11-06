import 'package:flutter/material.dart';
import 'package:ph2_pwm_hashfi/main.dart';
import 'package:ph2_pwm_hashfi/routers/routes_name.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool isVisibilePassword = true;

  TextEditingController emailTextController = TextEditingController();
  TextEditingController usernameTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();

  @override
  void dispose() {
    emailTextController.dispose();
    usernameTextController.dispose();
    passwordTextController.dispose();
    super.dispose();
  }

  Future<void> signIn() async {
    try {
      final response = await supabase.auth.signUp(
          email: emailTextController.text.trim(),
          password: passwordTextController.text.trim(),
          data: {'username': usernameTextController.text.trim()});

      if (response.session != null) {
        final userId = response.user!.id;
        final userProfile = await supabase
            .from('tbl_profiles')
            .select('username')
            .eq('user_uuid', userId)
            .single();

        final username = userProfile['username'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', username);

        if (!mounted) return;
        Navigator.pushReplacementNamed(context, RoutesName.home);
      }
    } on AuthException catch (e) {
      debugPrint(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 32,
            ),
            SizedBox(
              height: 380,
              child: Image.asset(
                'assets/images/login_image1.png',
              ),
            ),
            Text(
              "Sign Up",
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 24,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              margin: const EdgeInsets.symmetric(horizontal: 19),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
              ),
              child: TextField(
                cursorHeight: 16,
                controller: usernameTextController,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  floatingLabelStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  labelStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).colorScheme.secondary),
                  label: const Text('username'),
                ),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              margin: const EdgeInsets.symmetric(horizontal: 19),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
              ),
              child: TextField(
                cursorHeight: 16,
                controller: emailTextController,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  floatingLabelStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  labelStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).colorScheme.secondary),
                  label: const Text('email'),
                ),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              margin: const EdgeInsets.symmetric(horizontal: 19),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
              ),
              child: TextField(
                cursorHeight: 16,
                controller: passwordTextController,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  label: const Text('password'),
                  floatingLabelStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  labelStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).colorScheme.secondary),
                  suffixIcon: IconButton(
                    onPressed: () {
                      (!isVisibilePassword)
                          ? isVisibilePassword = true
                          : isVisibilePassword = false;
                      setState(() {});
                    },
                    icon: Icon(
                      (isVisibilePassword == true)
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
                obscureText: (!isVisibilePassword) ? false : true,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account?"),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, RoutesName.login);
                  },
                  style: ButtonStyle(
                    foregroundColor: WidgetStateProperty.all(Colors.blue),
                  ),
                  child: const Text(
                    "Login",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
            const SizedBox(height: 32),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  signIn();
                },
                child: const Text(
                  'Sign Up',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 24)
          ],
        ),
      ),
    );
  }
}
