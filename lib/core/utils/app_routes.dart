import 'package:UniStack/features/home/view/home_view.dart';
import 'package:UniStack/onboarding_view.dart';
import 'package:UniStack/splash_view.dart';
import 'package:get/get_navigation/get_navigation.dart';

class AppRoutes {
  static const String home = "/";
  static const String login = "/login";
  static const String register = "/register";
  static const String splash = "/splash";
  static const String onBoarding = "/onBoarding";

  static List<GetPage> pages = [
    GetPage(
      name: splash,
      page: () => const SplashView(),
    ),
    GetPage(name: onBoarding, page: () => const OnboardingView()),
    // GetPage(
    //   name: login,
    //   page: () => const LoginScreen(),
    // ),
    // GetPage(
    //   name: register,
    //   page: () => const RegisterScreen(),
    // ),
    GetPage(name: home, page: () => const HomeView()),
  ];
}
