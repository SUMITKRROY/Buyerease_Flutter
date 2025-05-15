import 'package:flutter/material.dart';
import 'package:buyerease/view/login/login.dart';
import 'package:buyerease/components/custom_text.dart';
import 'package:buyerease/components/custom_text_form_field.dart';
import 'package:flutter/services.dart';
import 'package:buyerease/routes/route_path.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:buyerease/view/homepage/homepage.dart';
import 'package:buyerease/routes/page_route.dart';

import 'package:buyerease/provider/community/community_code_cubit.dart';

import '../../services/share_pref.dart';

class CommunityCodeScreen extends StatefulWidget {
  const CommunityCodeScreen({super.key});

  @override
  State<CommunityCodeScreen> createState() => _CommunityCodeScreenState();
}

class _CommunityCodeScreenState extends State<CommunityCodeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkExistingCode();
  }

  Future<void> _checkExistingCode() async {
    final existingCode = await SharedPrefService.getCommunityCode();
    if (existingCode != null) {
      setState(() {
        _codeController.text = existingCode;
      });
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _submitCode() {
    if (_formKey.currentState!.validate()) {
      context.read<CommunityCodeCubit>().getCommunityCode(_codeController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocListener<CommunityCodeCubit, CommunityCodeState>(
      listener: (context, state) async {
        if (state is CommunityCodeLoaded) {
          final responseData = state.responseData;
          print('Full Response Data: $responseData');

          // Extract the URLs from the response data
          final String downloadUrl = responseData['DownloadURL'] ?? '';
          final String apiUrl = responseData['APIURL'] ?? '';
          final String communityCode = _codeController.text;

          // Store the URLs and community code
          await SharedPrefService.storeUrls(
            downloadUrl: downloadUrl,
            apiUrl: apiUrl,
            communityCode: communityCode,
          );

          // Navigate to login screen with the response data
          Navigator.of(context).pushReplacementNamed(
            RoutePath.login,
            arguments: responseData,
          );
        } else if (state is CommunityCodeError) {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: theme.colorScheme.error,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
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
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 40),
                          Container(
                            height: 70.h,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/logo.png'),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          const CustomText(text: 'Welcome to Buyerease'),
                          const SizedBox(height: 10),
                          Text(
                            'Enter your community code to continue',
                            style: TextStyle(
                              fontSize: 16,
                              color: theme.colorScheme.onBackground.withOpacity(0.6),
                              letterSpacing: 0.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 40),
                          Form(
                            key: _formKey,
                            child: CustomTextFormField(
                              controller: _codeController,
                              hintText: 'Enter your community code',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a community code';
                                }
                                return null;
                              },
                              maxLength: 50,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(10),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),
                          BlocBuilder<CommunityCodeCubit, CommunityCodeState>(
                            builder: (context, state) {
                              return Container(
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
                                  onPressed: state is CommunityCodeLoading
                                      ? null
                                      : _submitCode,
                                  child: state is CommunityCodeLoading
                                      ? const CircularProgressIndicator(
                                      color: Colors.white)
                                      : Text(
                                    'Continue',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: theme.colorScheme.onPrimary,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Footer section
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
    );
  }
}
