import 'package:UniStack/core/error/error_view.dart';
import 'package:UniStack/features/auth/view/login_view.dart';
import 'package:UniStack/features/auth/view/signup_view.dart';
import 'package:UniStack/features/home/view/home_view.dart';
import 'package:UniStack/features/myQuestions/view/myQuestions_view.dart';
import 'package:UniStack/onboarding_view.dart';
import 'package:UniStack/root.dart';
import 'package:UniStack/splash_view.dart';
import 'package:get/get_navigation/get_navigation.dart';

class AppRoutes {
  static const String root = "/";
  static const String home = "/home";
  static const String login = "/login";
  static const String signUp = "/signUp";
  static const String splash = "/splash";
  static const String onBoarding = "/onBoarding";
  static const String myQuestions = "/myQuestions";
  static const String error = "/error";

  static List<GetPage> pages = [
    GetPage(name: splash, page: () => const SplashView()),
    GetPage(name: onBoarding, page: () => const OnboardingView()),
    GetPage(name: login, page: () => const LoginView()),
    GetPage(name: signUp, page: () => const SignupView()),
    GetPage(name: root, page: () => const Root()),
    GetPage(name: myQuestions, page: () => const MyQuestionsView()),
    GetPage(name: home, page: () => const HomeView()),
    GetPage(name: error, page: () => const ErrorView()),
  ];
}
