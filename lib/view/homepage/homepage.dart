import 'dart:async';
import 'package:buyerease/components/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../components/share_logs.dart';
import '../../config/api_route.dart';
import '../../services/share_pref.dart';
import '../../utils/fsl_log.dart';
import '../Inspection/inspection_list.dart';
import '../sync_inception/sync_inception.dart';
import '../sync_style/sync_style.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _hiveBox = Hive.box("mybox");
  String? _userName; // Store the user name

  List dataList = [
    {
      'title': 'Inspection',
      'icon': 'assets/images/icon0.png',
      'page': 'InspectionList.dart'
    },
    {
      'title': 'Sync Style',
      'icon': 'assets/images/icon1.png',
      'page': 'GetData.dart'
    },
    {
      'title': 'Sync Inspection',
      'icon': 'assets/images/icon2.png',
      'page': 'InspectionList.dart'
    },
    {
      'title': 'Style List',
      'icon': 'assets/images/icon3.png',
      'page': 'InspectionList.dart'
    },
  ];

  @override
  void initState() {
    super.initState();
    resetUrl();
    _loadUserName();
  }

  Future<void> resetUrl() async {
    final downloadUrl = await SharedPrefService.getDownloadUrl();
    final apiUrl = await SharedPrefService.getApiUrl();
    ApiRoute.resetConfig(downloadUrl!, apiUrl!);
  }

  Future<void> _loadUserName() async {
 //   final name = await SharedPrefService.getUserName(); // You must have this method
    setState(() {
    //  _userName = name ?? "Guest";
    });
  }

  Future<void> _logout() async {
    //await SharedPrefService.clear(); // Clear saved data
    Navigator.pushReplacementNamed(context, '/login'); // Navigate to login
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(name: ''),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
              ),
              accountName: Text(
                _userName ?? '',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              accountEmail: const Text(""),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40, color: theme.colorScheme.primary),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text("Share Log"),
              onTap: () {
                FslLog.shareLog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Logout", style: TextStyle(color: Colors.red)),
              onTap: _logout,
            ),
          ],
        ),
      ),
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
        child: SafeArea(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.8,
                child: GridView.builder(
                  itemCount: dataList.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    mainAxisExtent: 130,
                  ),
                  itemBuilder: (e, index) {
                    return GestureDetector(
                      onTap: () {
                        if (index == 0) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const InspectionList()),
                          );
                        } else if (index == 1) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const SyncStyle()),
                          );
                        } else if (index == 2) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const SyncInception()),
                          );
                        } else if (index == 3) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const SyncStyle()),
                          );
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              theme.colorScheme.primary.withOpacity(0.1),
                              theme.colorScheme.secondary.withOpacity(0.1),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: theme.shadowColor.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              dataList[index]['icon'],
                              width: 50,
                              height: 50,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              dataList[index]['title'],
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: theme.colorScheme.onBackground,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
