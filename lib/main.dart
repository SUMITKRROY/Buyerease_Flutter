import 'dart:async';
import 'package:buyerease/provider/community/community_code_cubit.dart';
import 'package:buyerease/provider/defect_master/defect_master_cubit.dart';
import 'package:buyerease/provider/download_image/download_image_cubit.dart';
import 'package:buyerease/provider/login_cubit/login_cubit.dart';
import 'package:buyerease/provider/sync_cubit/sync_cubit.dart';
import 'package:buyerease/provider/sync_to_server/sync_to_server_cubit.dart';
import 'package:buyerease/view/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'routes/my_routes.dart';
import 'routes/route_path.dart';
import 'config/theame_data.dart';

SharedPreferences? sp;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox("mybox");
  sp = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class TimerData extends ChangeNotifier {
  int _seconds = 0;
  Timer? _timer;

  int get seconds => _seconds;
  int get minutes => _seconds ~/ 60;
  int get hours => _seconds ~/ 3600;

  TimerData() {
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _seconds++;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // default — will override inside builder
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        final isTablet = MediaQuery.of(context).size.shortestSide >= 600;
        final designSize = isTablet ? const Size(768, 1024) : const Size(375, 812);

        return ScreenUtilInit(
          designSize: designSize,
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (_) => TimerData()),
              ],
              child: MultiBlocProvider(
                providers: [
                  BlocProvider(create: (_) => CommunityCodeCubit()),
                  BlocProvider(create: (_) => LoginCubit()),
                  BlocProvider(create: (_) => SyncCubit()),
                  BlocProvider(create: (_) => DefectMasterCubit()),
                  BlocProvider(create: (_) => DownloadImageCubit()),
                  BlocProvider(create: (_) => SyncToServerCubit()),
                ],
                child: MaterialApp(
                  title: 'BuyersEase',
                  debugShowCheckedModeBanner: false,
                  theme: lightMode,
                  initialRoute: RoutePath.splash,
                  onGenerateRoute: MyRoutes.generateRoute,
                ),
              ),
            );
          },
        );
      },
    );
  }
}


