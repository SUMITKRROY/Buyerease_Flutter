import 'dart:async';
import 'package:buyerease/database/table/user_master_table.dart';
import 'package:buyerease/view/homepage/homepage.dart';
import 'package:buyerease/view/community/community_code_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:buyerease/database/database_helper.dart';
import 'package:buyerease/routes/route_path.dart';

import '../../services/share_pref.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  final _hiveBox = Hive.box("mybox");
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isActive = true;
  String currentTime = 'No data';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeAnimation();
    database();
  }

  void _initializeAnimation() {
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _navigateToNextScreen();
      }
    });
  }

  void _navigateToNextScreen() async {
    final downloadUrl = await SharedPrefService.getDownloadUrl();
    final apiUrl = await SharedPrefService.getApiUrl();
    final userMaster = await UserMasterTable().getAll();


    if (downloadUrl == null && apiUrl == null) {
      // URLs exist, go to login page
      Navigator.of(context).pushReplacementNamed(RoutePath.community);
    } else if (userMaster.isNotEmpty) {
      Navigator.of(context).pushReplacementNamed(RoutePath.homepage);
    } else {
      Navigator.of(context).pushReplacementNamed(RoutePath.login);
    }
  }


  Future<void> database() async {
    final db = await DatabaseHelper().database;
  }

  @override
  void dispose() {
    _controller.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      _isActive = false;
    } else if (state == AppLifecycleState.resumed) {
      _isActive = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.primary.withOpacity(0.1),
              theme.colorScheme.background,
            ],
          ),
        ),
        child: Center(
          child: ScaleTransition(
            scale: _animation,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: theme.shadowColor.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Image.asset(
                'assets/images/logo.png',
                width: 200,
                height: 200,
              ),
            ),
          ),
        ),
      ),
    );
  }
} 