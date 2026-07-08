import 'package:enhanced_future_builder/enhanced_future_builder.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:superhut/welcomepage/view.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../bridge/getCoursePage.dart';
import '../../pages/score/scorepage.dart';
import '../../utils/hut_user_api.dart';
import '../../utils/token.dart';
import '../about/view.dart';
import '../../widgets/bouncing_widget.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  void initState() {
    super.initState();
    getBalance();
  }

  final hutUserApi = HutUserApi();
  String balance = "--";

  Future<void> getBalance() async {
    await hutUserApi.getCardBalance().then((value) {
      balance = value.toString() ?? '--';
      setState(() {
        balance = balance;
      });
    });
  }

  final Uri _url = Uri.parse(
    'alipays://platformapi/startapp?appId=2019030163398604&page=pages/index/index',
  );

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  Future<Map> getBaseData() async {
    final prefs = await SharedPreferences.getInstance();
    String name =  prefs.getString('name') ?? "人类";
    String entranceYear =  prefs.getString('entranceYear') ?? "0001";
    String academyName =  prefs.getString('academyName') ?? "地球学院";
    String clsName = prefs.getString('clsName') ?? "地球1班";
    String yxzxf =  prefs.getString('yxzxf') ?? "-";
    String zxfjd =  prefs.getString('zxfjd') ?? "-";
    String pjxfjd =  prefs.getString('pjxfjd') ?? "-";
    Map data = {
      "name": name,
      "entranceYear": entranceYear,
      "academyName": academyName,
      "clsName": clsName,
      "yxzxf": yxzxf,
      "zxfjd": zxfjd,
      "pjxfjd": pjxfjd,
    };
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: EnhancedFutureBuilder(
        future: getBaseData(),
        rememberFutureResult: true,
        whenDone: (d) {
          return CustomScrollView(
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            slivers: [
              SliverAppBar.large(
                title: Text(
                  "你好，${d['name']}",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                backgroundColor: Theme.of(context).colorScheme.surface,
                scrolledUnderElevation: 0,
                pinned: true,
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // 学分与绩点卡片
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            title: "已修学分",
                            value: d['yxzxf'],
                            color: Theme.of(context).colorScheme.primaryContainer,
                            textColor: Theme.of(context).colorScheme.onPrimaryContainer,
                            onTap: () async {
                              await renewToken(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ScorePage(),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildStatCard(
                            title: "我的绩点",
                            value: d['pjxfjd'],
                            color: Theme.of(context).colorScheme.secondaryContainer,
                            textColor: Theme.of(context).colorScheme.onSecondaryContainer,
                            onTap: () async {
                              await renewToken(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ScorePage(),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // 校园卡
                    BouncingWidget(
                      child: Card.filled(
                        elevation: 0,
                        color: Theme.of(context).colorScheme.tertiaryContainer,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '校园卡',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).colorScheme.onTertiaryContainer,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    balance,
                                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).colorScheme.onTertiaryContainer,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 6),
                                    child: Text(
                                      'CNY',
                                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        color: Theme.of(context).colorScheme.onTertiaryContainer.withOpacity(0.7),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity,
                                child: FilledButton.tonal(
                                  onPressed: () {
                                    _launchUrl();
                                  },
                                  style: FilledButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: const Text('充值', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    Text(
                      "功能与设置",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 功能项
                    _buildFunctionItem(
                      icon: Icons.refresh_rounded,
                      title: "刷新课表",
                      onTap: () async {
                        await renewToken(context);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => Getcoursepage(renew: true),
                          ),
                        );
                      },
                    ),
                    _buildFunctionItem(
                      icon: Icons.info_outline_rounded,
                      title: "关于软件",
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => AboutPage()),
                        );
                      },
                    ),
                    _buildFunctionItem(
                      icon: Icons.logout_rounded,
                      title: "退出登录",
                      onTap: () async {
                        final prefs = await SharedPreferences.getInstance();
                        prefs.setString('user', "");
                        prefs.setString('password', "");
                        await prefs.setBool('isFirstOpen', true);
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => WelcomepagePage(),
                            ),
                          );
                        });
                      },
                      isDestructive: true,
                    ),
                    const SizedBox(height: 100),
                  ]),
                ),
              ),
            ],
          );
        },
        whenNotDone: const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _buildStatCard({
    required VoidCallback onTap,
    required String title,
    required String value,
    required Color color,
    required Color textColor,
  }) {
    return BouncingWidget(
      onPressed: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: textColor.withOpacity(0.8),
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: textColor.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Icon(Icons.arrow_forward_rounded, size: 20, color: textColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFunctionItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return BouncingWidget(
      onPressed: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.4),
          borderRadius: BorderRadius.circular(20),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDestructive 
                  ? Theme.of(context).colorScheme.errorContainer 
                  : Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon, 
              color: isDestructive 
                  ? Theme.of(context).colorScheme.onErrorContainer 
                  : Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          title: Text(
            title, 
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: isDestructive ? Theme.of(context).colorScheme.error : null,
            ),
          ),
          trailing: Icon(Icons.chevron_right_rounded, color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
      ),
    );
  }
}
