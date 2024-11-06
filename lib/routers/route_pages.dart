import 'package:flutter/material.dart';
import 'package:ph2_pwm_hashfi/pages/detail_student_page.dart';
import 'package:ph2_pwm_hashfi/pages/home_page.dart';
import 'package:ph2_pwm_hashfi/pages/login_page.dart';
import 'package:ph2_pwm_hashfi/pages/signup_page.dart';
import 'package:ph2_pwm_hashfi/routers/routes_name.dart';

class DetailArguments {
  final String nisn;

  DetailArguments(this.nisn);
}

class RoutePages {
  Route onRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case RoutesName.signUp:
        return MaterialPageRoute(
          builder: (context) => const SignupPage(),
        );
      case RoutesName.login:
        return MaterialPageRoute(
          builder: (context) => const LoginPage(),
        );
      case RoutesName.home:
        return MaterialPageRoute(
          builder: (context) => const HomePage(),
        );
      case RoutesName.detail:
        final args = routeSettings.arguments as DetailArguments?;
        return MaterialPageRoute(
          builder: (context) => DetailStudentPage(
            nisnValue: args?.nisn,
          ),
        );
      default:
        return MaterialPageRoute(builder: (context) => const SignupPage());
    }
  }
}
