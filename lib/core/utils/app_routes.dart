import 'package:UniStack/about_view.dart';
import 'package:UniStack/core/binding/auth_bindin.dart';
import 'package:UniStack/core/binding/root_binding.dart';
import 'package:UniStack/core/error/error_view.dart';
import 'package:UniStack/features/answers/view/answers_view.dart';
import 'package:UniStack/features/auth/view/login_view.dart';
import 'package:UniStack/features/auth/view/profile_view.dart';
import 'package:UniStack/features/auth/view/signup_view.dart';
import 'package:UniStack/features/home/view/home_view.dart';
import 'package:UniStack/features/myQuestions/view/edit_question_view.dart';
import 'package:UniStack/features/myQuestions/view/myQuestions_view.dart';
import 'package:UniStack/features/settings/view/settings_view.dart';
import 'package:UniStack/onboarding_view.dart';
import 'package:UniStack/root.dart';
import 'package:UniStack/splash_view.dart';
import 'package:get/get_core/src/get_main.dart';
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
  static const String profile = "/profile";
  static const String editQuestion = "/editQuestion";
  static const String answers = "/answers";
  static const String settings = "/settings";
  static const String about = "/about";

  static List<GetPage> pages = [
    GetPage(
      name: splash,
      page: () => const SplashView(),
      bindings: [AuthBinding()],
    ),
    GetPage(
      name: onBoarding,
      page: () => const OnboardingView(),
      bindings: [AuthBinding()],
    ),
    GetPage(
      name: login,
      page: () => const LoginView(),
      bindings: [AuthBinding()],
    ),
    GetPage(
      name: signUp,
      page: () => const SignupView(),
      bindings: [AuthBinding()],
    ),
    GetPage(name: root, page: () => const Root(), bindings: [RootBinding()]),
    GetPage(
      name: myQuestions,
      page: () => const MyQuestionsView(),
      bindings: [RootBinding()],
    ),
    GetPage(
      name: home,
      page: () => const HomeView(),
      bindings: [RootBinding()],
    ),
    GetPage(name: error, page: () => const ErrorView()),
    GetPage(name: profile, page: () => ProfileView()),
    GetPage(
      name: editQuestion,
      page: () => EditQuestionView(question: Get.arguments),
      bindings: [RootBinding()],
    ),
    GetPage(
      name: answers,
      page: () => AnswersView(question: Get.arguments),
      // bindings: [RootBinding()],
    ),
    GetPage(name: settings, page: () => SettingsView()),
    GetPage(name: about, page: () => AboutView()),
  ];
}
