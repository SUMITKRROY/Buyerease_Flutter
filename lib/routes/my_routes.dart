import 'package:flutter/material.dart';
import '../routes/route_path.dart';
import '../view/splash/splash_screen.dart';
import '../view/login/login.dart';
import '../view/community/community_code_screen.dart';
import '../view/homepage/homepage.dart';
import '../view/register/register.dart';
import '../view/po/po_page.dart';
import '../view/details/detail_page1.dart';
import '../view/Inspection/inspection_list.dart';

import '../view/sync_style/sync_style.dart';
import '../view/sync_inception/sync_inception.dart';
import '../view/over_all_result/over_all_result.dart';
import 'page_route.dart';

class MyRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutePath.splash:
        return CustomPageRoute(child: const SplashScreen(), settings: settings);
      case RoutePath.login:
        return CustomPageRoute(child: const Login(), settings: settings);
      case RoutePath.community:
        return CustomPageRoute(child: const CommunityCodeScreen(), settings: settings);
      case RoutePath.homepage:
        return CustomPageRoute(child: const HomePage(), settings: settings);
      case RoutePath.register:
        return CustomPageRoute(child: const Register(), settings: settings);
      // case RoutePath.po:
      //   final id = settings.arguments as String? ?? '';
      //   return CustomPageRoute(child: PoPage(data: id), settings: settings);
      case RoutePath.details:
        final id = settings.arguments as String? ?? '';
        return CustomPageRoute(child: DetailPageOne(id: id), settings: settings);
      case RoutePath.inspection:
        return CustomPageRoute(child: const InspectionList(), settings: settings);
      case RoutePath.syncStyle:
        return CustomPageRoute(child: const SyncStyle(), settings: settings);
      case RoutePath.syncInception:
        return CustomPageRoute(child: const SyncInception(), settings: settings);
      case RoutePath.overAllResult:
        return CustomPageRoute(child: const OverAllResult(id: ''), settings: settings);
      default:
        return CustomPageRoute(
          child: Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
          settings: settings,
        );
    }
  }
} 