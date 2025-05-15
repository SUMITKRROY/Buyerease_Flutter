import 'dart:async';
import 'package:buyerease/provider/community/community_code_cubit.dart';
import 'package:buyerease/provider/login_cubit/login_cubit.dart';
import 'package:buyerease/provider/sync_cubit/sync_cubit.dart';
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
      designSize: const Size(375, 812), // iPhone 13 Pro Max dimensions
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => TimerData()),
            BlocProvider<CommunityCodeCubit>(create: (context) => CommunityCodeCubit()),
            BlocProvider<LoginCubit>(create: (context) => LoginCubit()),
            BlocProvider<SyncCubit>(create: (context) => SyncCubit()),
          ],

          child: MaterialApp(
            title: 'BuyersEase',
            debugShowCheckedModeBanner: false,
            theme: lightMode,
            // darkTheme: darkMode,
            // themeMode: ThemeMode.system,
            initialRoute: RoutePath.splash,
            onGenerateRoute: MyRoutes.generateRoute,
          ),
        );
      },
    );
  }
}
