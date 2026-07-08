import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:superhut/pages/Commentary/CommentaryPage1.dart';
import 'package:superhut/pages/Electricitybill/electricityPage.dart';
import 'package:superhut/pages/ExamSchedule/exam_schedule_page.dart';
import 'package:superhut/pages/drink/view/view.dart';
import 'package:superhut/pages/freeroom/building.dart';
import 'package:superhut/pages/hutpages/hutmain.dart';
import 'package:superhut/pages/water/view.dart';
import 'package:superhut/live_notification_manager.dart';

import '../../pages/score/scorepage.dart';
import '../../utils/token.dart';
import '../../widgets/bouncing_widget.dart';

class FunctionPage extends StatefulWidget {
  const FunctionPage({super.key});

  @override
  State<FunctionPage> createState() => _FunctionPageState();
}

class _FunctionPageState extends State<FunctionPage> {
  final Set<String> _loadingFunctions = <String>{};

  void _setLoading(String functionId, bool isLoading) {
    setState(() {
      if (isLoading) {
        _loadingFunctions.add(functionId);
      } else {
        _loadingFunctions.remove(functionId);
      }
    });
  }

  bool _isLoading(String functionId) {
    return _loadingFunctions.contains(functionId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        slivers: [
          SliverAppBar.large(
            title: Text(
              "功能与服务",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Theme.of(context).colorScheme.surface,
            scrolledUnderElevation: 0,
            pinned: true,
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildActivityCard(
                  id: "empty_room",
                  title: "空教室查询",
                  subtitle: "快速寻找自习室",
                  iconData: Icons.school_rounded,
                  color: Theme.of(context).colorScheme.primaryContainer,
                  iconColor: Theme.of(context).colorScheme.onPrimaryContainer,
                  hasArrow: true,
                  onTap: () async {
                    _setLoading("empty_room", true);
                    try {
                      await renewToken(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BuildingPage()),
                      );
                    } finally {
                      _setLoading("empty_room", false);
                    }
                  },
                ),
                const SizedBox(height: 16),
                _buildActivityCard(
                  id: "score",
                  title: "成绩查询",
                  subtitle: "查看历年期末成绩",
                  iconData: Icons.description_rounded,
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  iconColor: Theme.of(context).colorScheme.onSecondaryContainer,
                  hasArrow: true,
                  onTap: () async {
                    _setLoading("score", true);
                    try {
                      await renewToken(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ScorePage()),
                      );
                    } finally {
                      _setLoading("score", false);
                    }
                  },
                ),
                const SizedBox(height: 16),
                _buildActivityCard(
                  id: "drink",
                  title: "宿舍喝水",
                  subtitle: "寝室饮水机扫码",
                  iconData: Icons.water_drop_rounded,
                  color: Theme.of(context).colorScheme.tertiaryContainer,
                  iconColor: Theme.of(context).colorScheme.onTertiaryContainer,
                  hasArrow: true,
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FunctionDrinkPage()),
                    );
                  },
                ),
                const SizedBox(height: 16),
                _buildActivityCard(
                  id: "hot_water",
                  title: "洗浴热水",
                  subtitle: "宿舍淋浴扫码",
                  iconData: Icons.shower_rounded,
                  color: Theme.of(context).colorScheme.errorContainer,
                  iconColor: Theme.of(context).colorScheme.onErrorContainer,
                  hasArrow: true,
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FunctionHotWaterPage()),
                    );
                  },
                ),
                const SizedBox(height: 16),
                _buildActivityCard(
                  id: "exam",
                  title: "考试安排",
                  subtitle: "查看考场及座位号",
                  iconData: Icons.edit_document,
                  color: Theme.of(context).colorScheme.primaryContainer,
                  iconColor: Theme.of(context).colorScheme.onPrimaryContainer,
                  hasArrow: true,
                  onTap: () async {
                    _setLoading("exam", true);
                    try {
                      await renewToken(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ExamSchedulePage()),
                      );
                    } finally {
                      _setLoading("exam", false);
                    }
                  },
                ),
                const SizedBox(height: 16),
                _buildActivityCard(
                  id: "electricity",
                  title: "电费充值",
                  subtitle: "宿舍剩余电量查询",
                  iconData: Icons.flash_on_rounded,
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  iconColor: Theme.of(context).colorScheme.onSecondaryContainer,
                  hasArrow: true,
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ElectricityPage()),
                    );
                  },
                ),
                const SizedBox(height: 16),
                _buildActivityCard(
                  id: "commentary",
                  title: "学生评教",
                  subtitle: "期末教学评价入口",
                  iconData: Icons.thumbs_up_down_rounded,
                  color: Theme.of(context).colorScheme.tertiaryContainer,
                  iconColor: Theme.of(context).colorScheme.onTertiaryContainer,
                  hasArrow: true,
                  onTap: () async {
                    _setLoading("commentary", true);
                    try {
                      await renewToken(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => commentaryPage1()),
                      );
                    } finally {
                      _setLoading("commentary", false);
                    }
                  },
                ),
                const SizedBox(height: 16),
                _buildActivityCard(
                  id: "hut_main",
                  title: "智慧工大",
                  subtitle: "教务系统原生入口",
                  iconData: Icons.explore_rounded,
                  color: Theme.of(context).colorScheme.primaryContainer,
                  iconColor: Theme.of(context).colorScheme.onPrimaryContainer,
                  hasArrow: true,
                  onTap: () async {
                    await renewToken(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HutMainPage()),
                    );
                  },
                ),
                const SizedBox(height: 120),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard({
    required String id,
    required String title,
    String? subtitle,
    required IconData iconData,
    required Color color,
    required Color iconColor,
    bool hasArrow = false,
    required VoidCallback onTap,
  }) {
    final isLoading = _isLoading(id);

    return BouncingWidget(
      onPressed: isLoading ? null : onTap,
      child: Card.filled(
        elevation: 0,
        color: Theme.of(context).colorScheme.surfaceContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16),
                child: Icon(iconData, size: 28, color: iconColor),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ]
                  ],
                ),
              ),
              if (hasArrow)
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(10),
                  child: isLoading
                      ? LoadingAnimationWidget.inkDrop(
                          color: Theme.of(context).colorScheme.primary,
                          size: 18,
                        )
                      : Icon(Icons.arrow_forward_rounded, size: 18, color: Theme.of(context).colorScheme.onSurfaceVariant),
                )
            ],
          ),
        ),
      ),
    );
  }
}
