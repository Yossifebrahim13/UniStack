import 'package:UniStack/core/utils/app_colors.dart';
import 'package:UniStack/core/utils/app_routes.dart';
import 'package:UniStack/core/utils/app_sizes.dart';
import 'package:UniStack/features/home/widgets/quick_action_card.dart';
import 'package:UniStack/features/home/widgets/statues_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/route_manager.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    List quickActions = [
      {
        "title": "value",
        "icon": Icons.add_ic_call_rounded,
        "action": () => {}
      },
      {
        "title": "ask",
        "icon": Icons.question_mark_rounded,
        "action": () => {}
      },
      {
        "title": "profile",
        "icon": Icons.person,
        "action": () => {}
      },
      {
        "title": "about",
        "icon": Icons.info,
        "action": () => {}
      }
    ];

    final screenWidth = AppSizes(context).screenWidth;
    final screenHeight = AppSizes(context).screenHeight;

    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.02, vertical: screenHeight * 0.02),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.asset("lib/core/assets/img/applogo.jpeg",
                    fit: BoxFit.cover,
                    width: screenWidth * 0.1,
                    height: screenWidth * 0.1), // خليتها سكوير عشان اللوجو يظبط
              ),
              Gap(screenWidth * 0.02),
              Text(
                "UniStack",
                style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.06),
              )
            ],
          ),
        ),
        actions: [
          IconButton(onPressed: () => {}, icon: const Icon(Icons.notifications))
        ],
      ),
      // استخدمنا ListView بدل Column عشان الصفحة تقبل Scroll لما تملى المساحة الفاضية
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        children: [
          const Gap(20),

          // النص الترحيبي
          Text(
            "Hello, Yossif 👋",
            style: TextStyle(
              fontSize: screenWidth * 0.08,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),

          const Gap(25),

          // الصف اللي فيه الكارتين (النقط والترتيب)
          Row(
            children: [
              Expanded(
                  child: buildStatCard("Total Points", "2,450", "PTS",
                      Icons.wallet, Colors.blue)),
              const Gap(15),
              Expanded(
                  child: buildStatCard("Global Rank", "12th", "RANK",
                      Icons.emoji_events, Colors.orange)),
            ],
          ),
          Gap(screenHeight * 0.06),

          Text(
            "Quick Actions",
            style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: screenWidth * 0.04),
          ),
          Gap(screenHeight * 0.02),
          
          SizedBox(
            height: screenHeight * 0.15,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) =>
                  quickActionsCard(
                quickActions[index]["icon"],
                quickActions[index]["title"],
                quickActions[index]["action"],
              ),
              separatorBuilder: (BuildContext context, int index) =>
                  Gap(screenWidth * 0.02),
              itemCount: quickActions.length,
            ),
          ),

  
          Gap(screenHeight * 0.05),
          
          Text(
            "Announcements",
            style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: screenWidth * 0.04),
          ),
          Gap(screenHeight * 0.02),

          // كارت ستاتيك للترحيب أو الأخبار
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.blue.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.campaign_rounded, color: Colors.blue, size: 30),
                const Gap(15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome to UniStack!",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary),
                      ),
                      const Text(
                        "Check out the new learning resources available now.",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Gap(screenHeight * 0.03),

          // كارت ستاتيك تاني للـ Guidelines
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(20),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.rule_rounded, color: Colors.orange),
              title: Text(
                "User Guidelines",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              subtitle: const Text("Keep our community safe and helpful"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 15),
              onTap: () {},
            ),
          ),
          
          const Gap(40), // مسافة في الآخر عشان الـ Scroll يكون مريح
        ],
      ),
    );
  }
}