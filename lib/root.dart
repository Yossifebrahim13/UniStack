import 'package:UniStack/shared/widgets/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:UniStack/core/utils/app_colors.dart';
import 'package:UniStack/features/home/view/home_view.dart';
import 'package:UniStack/features/questions/view/questions_view.dart';
import 'package:UniStack/features/myQuestions/view/myQuestions_view.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class Root extends StatefulWidget {
  const Root({super.key});

  static final GlobalKey<_RootState> rootKey = GlobalKey<_RootState>();

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  int currentIndex = 1;
  late final PageController _pageController;

  final List<Widget> screens = const [
    QuestionsView(),
    HomeView(),
    MyQuestionsView(),
  ];

  final List<IconData> icons = [
    Icons.question_answer,
    Icons.home_rounded,
    Icons.question_mark_sharp,
  ];

  final List<String> labels = ['Questions', 'Home', 'My Questions'];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void setPage(int index) {
    if (index >= 0 && index < screens.length) {
      setState(() {
        currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: currentIndex, children: screens),

      // FAB
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAskQuestionBottomSheet();
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: AppColors.card),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      // Bottom Navigation Bar
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                color: AppColors.shadow,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(screens.length, (index) {
              final isSelected = currentIndex == index;
              return GestureDetector(
                onTap: () {
                  setPage(index);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: EdgeInsets.symmetric(
                    horizontal: isSelected ? 16 : 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary.withOpacity(0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      if (isSelected) ...[
                        const SizedBox(width: 6),
                        Text(
                          labels[index],
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                      Icon(
                        icons[index],
                        color: isSelected ? AppColors.primary : AppColors.icon,
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
