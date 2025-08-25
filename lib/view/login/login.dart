import 'dart:io';
import 'package:buyerease/config/api_route.dart';
import 'package:buyerease/main.dart';
import 'package:buyerease/provider/login_cubit/login_cubit.dart';
import 'package:buyerease/provider/login_cubit/login_cubit.dart';
import 'package:buyerease/routes/route_path.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';
import '../../services/share_pref.dart';
import '../homepage/homepage.dart';
import 'package:buyerease/utils/toast.dart';
import 'package:buyerease/utils/loading.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:buyerease/database/database_helper.dart';
import 'package:buyerease/components/custom_text.dart';
import 'package:buyerease/components/custom_text_form_field.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _hiveBox = Hive.box("mybox");
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _passwordVisible = false;
  bool loading = false;

  String name = '';
  String password = '';
  String deviceID = '';

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // login() async {
  //   if (_formKey.currentState!.validate()) {
  //     name = _usernameController.text.trim();
  //     password = _passwordController.text.trim();
  //
  //     if (name == '') {
  //       showToast('Please Enter Name', false);
  //       setState(() {
  //         loading = false;
  //       });
  //     } else if (password == '') {
  //       showToast('Please Enter Password', false);
  //       setState(() {
  //         loading = false;
  //       });
  //     }
  //     if (name != '' && password != "") {
  //       final apiUrl =
  //           'http://www.buyerease.co.in/buyereasewebAPI/api/Account/AuthenticateUser';
  //       Map<String, dynamic> requestBody = {
  //         "UserID": name,
  //         "Password": password,
  //         "DeviceID": "7c7bc1f1b2736ba0",
  //         "DeviceIP": "10.0.2.16",
  //         "HDDSerialNo": "",
  //         "DeviceType": "A",
  //         "Location": ""
  //       };
  //       try {
  //         debugPrint('vikram login $apiUrl $requestBody');
  //         final responseData = await fetchDataFromAPI(apiUrl, requestBody);
  //         if (responseData['Message'].toString() == 'Login Successfull.') {
  //           debugPrint('responseData ${responseData['Data'][0]['pUserID']}');
  //           loading = false;
  //           setState(() async {
  //             sp?.setString('User', name);
  //             sp?.setString('Password', password);
  //             sp?.setString('UserID', responseData['Data'][0]['pUserID']);
  //             SQLHelper.createItem(responseData);
  //             String path = await getDatabasesPath();
  //             debugPrint('path$path');
  //             _hiveBox.put('loggedIn', true);
  //             Navigator.pushReplacement(
  //                 context, MaterialPageRoute(builder: (_) => const HomePage()));
  //           });
  //         } else {
  //           showToast(responseData['Message'].toString(), false);
  //           loading = false;
  //           setState(() {});
  //         }
  //       } catch (e) {
  //         showToast('$e', false);
  //         loading = false;
  //         setState(() {});
  //       }
  //     }
  //   }
  // }


  @override
  void initState() {
    super.initState();
    resetUrl();
    getId();
  }
  Future<void> resetUrl() async {
    final downloadUrl = await SharedPrefService.getDownloadUrl();
    final apiUrl = await SharedPrefService.getApiUrl();
    ApiRoute.resetConfig(downloadUrl!, apiUrl!);
  }

  Future<Object?> getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      deviceID = iosDeviceInfo.identifierForVendor!;
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      deviceID = androidDeviceInfo.serialNumber;
      debugPrint('deviceID $deviceID');
      print('Brand: ${androidDeviceInfo.brand}');
      print('Model: ${androidDeviceInfo.model}');
      print('Device: ${androidDeviceInfo.device}');
      print('Android ID: ${androidDeviceInfo.id}');
      print('Fingerprint: ${androidDeviceInfo.fingerprint}');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) async {
        if (state is LoginLoading) {
          setState(() {
            loading = true;
          });
        } else if (state is LoginSuccess) {
          setState(() {
            loading = false;
          });

          sp?.setString('User', _usernameController.text.trim());
          sp?.setString('Password', _passwordController.text.trim());
          sp?.setString('UserID', state.userData['pUserID']);
          _hiveBox.put('loggedIn', true);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomePage()),
          );
        } else if (state is LoginFailure) {
          setState(() {
            loading = false;
          });
          showToast(state.error, false);
        }
      },
      child: WillPopScope(
        onWillPop: () {
          exit(0);
        },
        child: Scaffold(

        body: loading == true
            ? const Center(child: Loading())
            : Container(
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
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Container(
                      height: MediaQuery.of(context).size.height * .90,
                      child: SafeArea(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20.w,
                                vertical: 20.h,
                              ),
                              width: 0.8.sw,
                              height: 0.15.sh,
                              child: Image.asset(
                                'assets/images/logo.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                            const Spacer(flex: 1),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              margin: EdgeInsets.symmetric(horizontal: 20.w),
                              width: 0.9.sw,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surface,
                                borderRadius: BorderRadius.circular(16.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: theme.shadowColor.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  SizedBox(height: 30.h),
                                  Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10.w,
                                      vertical: 5.h,
                                    ),
                                    child: const CustomText(
                                      text: 'Log In',
                                      fontSize: 24,
                                    ),
                                  ),
                                  SizedBox(height: 30.h),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                                    child: CustomTextFormField(
                                      controller: _usernameController,
                                      hintText: "Enter User name",
                                      prefixIcon: Icons.person,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your username';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 20.h),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                                    child: CustomTextFormField(
                                      controller: _passwordController,
                                      hintText: "Enter password",
                                      prefixIcon: Icons.lock,
                                      obscureText: !_passwordVisible,
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _passwordVisible
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: theme.colorScheme.primary.withOpacity(0.7),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _passwordVisible = !_passwordVisible;
                                          });
                                        },
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your password';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 30.h),
                                  Container(
                                    width: 0.8.sw,
                                    height: 45.h,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          theme.colorScheme.primary,
                                          theme.colorScheme.secondary,
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(8.r),
                                      boxShadow: [
                                        BoxShadow(
                                          color: theme.colorScheme.primary.withOpacity(0.3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: TextButton(
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          context.read<LoginCubit>().login(
                                            user: _usernameController.text.trim(),
                                            password: _passwordController.text.trim(),
                                            deviceId: deviceID,
                                            deviceIP: "10.0.2.16",
                                            hddSerialNo: "",
                                            deviceType: "A",
                                            location: "",
                                          );
                                        }
                                        // Old method call (commented out after switching to cubit)
                                        // setState(() => loading = true);
                                        // await login();
                                      },

                                      child: Text(
                                        'Login',
                                        style: TextStyle(
                                          color: theme.colorScheme.onPrimary,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20.h),
                                ],
                              ),
                            ),
                            SizedBox(height: 20.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Change Community Code',
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    color: theme.colorScheme.onBackground.withOpacity(0.7),
                                  ),
                                ),
                                SizedBox(width: 5.w),
                                GestureDetector(
                                  child: Text(
                                    'Click Here',
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      color: theme.colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.pushReplacementNamed(context, RoutePath.community);
                                  },
                                ),
                              ],
                            ),
                            const Spacer(),
                            Container(
                              width: 1.sw,
                              margin: EdgeInsets.symmetric(vertical: 20.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Powered & Maintenance By:-',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: theme.colorScheme.onBackground.withOpacity(0.7),
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                  Text(
                                    'FSL Software Technologies Limited',
                                    style: TextStyle(
                                      color: theme.colorScheme.onBackground.withOpacity(0.7),
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
      ),
    ),
);
  }
}
