
import 'package:buyerease/utils/toast.dart';
import 'package:flutter/material.dart';

import '../networks/endpoints.dart';
import '../post/post_api_call.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();

  bool _passwordVisible = false;
  bool showErrorMessage = false;
  bool rememberMe = false;
  bool loading = false;

  String server = '';
  String userid = '';
  String password = '';
  String community = '';
  String company = '';

  Future<void> register() async {
    if (server == '') {
      showToast('Please Enter IP Address', false);
      setState(() {
        loading = false;
      });
    } else if (userid == '') {
      showToast('Please Enter Name', false);
      setState(() {
        loading = false;
      });
    } else if (password == '') {
      showToast('Please Enter Password', false);
      setState(() {
        loading = false;
      });
    }
    if (server != '' && userid != '' && password != "") {
      final apiUrl = 'http://$server${APIUrls.baseUrl}${APIUrls.urlLogin}';
      Map<String, dynamic> requestBody = {
        "ServerId": "userid",
        "DBUserID": "password",
        "DBPassword": "7c7bc1f1b2736ba0",
        "Coummity": "server",
        "Company": ""
      };
      try {
        final responseData = await fetchDataFromAPI(apiUrl, requestBody);
        if (responseData['Message'].toString() == 'Login Successfull.') {
          loading = false;
        } else {
          showToast(responseData['Message'].toString(), false);
          loading = false;
          setState(() {});
        }
      } catch (e) {
        showToast('$e', false);
        loading = false;
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.2,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/logo.png')))),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    // margin: const EdgeInsets.symmetric(horizontal: 20),
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.45,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: Colors.blue[50], /*border: Border.all(color: Colors., width: 0.5),*/borderRadius: const BorderRadius.all(Radius.circular(8))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            child: const Text('Register', style: TextStyle(fontSize: 17, color: Colors.black, fontWeight: FontWeight.w700))),
                        const SizedBox(height: 10),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.black, width: 0.1),
                              borderRadius: BorderRadius.circular(12)),
                          child: TextFormField(
                            keyboardType: TextInputType.name,
                            onChanged: (value) => server = value.trim(),
                            style: const TextStyle(fontSize: 12, color: Colors.black),
                            decoration: const InputDecoration(
                              icon: Icon(Icons.code, size: 20),
                              border: InputBorder.none,
                              hintText: "Enter Server ID",
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(color: Colors.white, border:Border.all(color: Colors.black, width: 0.1), borderRadius: BorderRadius.circular(12)),
                          child: TextFormField(
                            keyboardType: TextInputType.name,
                            onChanged: (value) => userid = value.trim(),
                            style: const TextStyle(fontSize: 12, color: Colors.black),
                            decoration: const InputDecoration(
                              icon: Icon(Icons.person, size: 20),
                              border: InputBorder.none,
                              hintText: "Enter DB UserId",
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.black, width: 0.1),
                              borderRadius: BorderRadius.circular(12)),
                          child: TextFormField(
                              obscureText: !_passwordVisible,
                              keyboardType: TextInputType.name,
                              onChanged: (value) => password = value.trim(),
                              style: const TextStyle(fontSize: 12, color: Colors.black),
                              decoration: InputDecoration(
                                icon: const Icon(Icons.lock, size: 20),
                                border: InputBorder.none,
                                hintText: "Enter DB password",
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _passwordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.blue.shade200,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _passwordVisible = !_passwordVisible;
                                    });
                                  },
                                ),
                              )),
                        ),
                        const SizedBox(height: 10),
                        Container(width: MediaQuery.of(context).size.width * 0.8,
                          decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.black, width: 0.1), borderRadius: BorderRadius.circular(12)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(width: 18),
                              Image.asset('assets/images/building.png', width: 20, height: 20),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.7,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                // decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.black, width: 0.1), borderRadius: BorderRadius.circular(12)),
                                child: TextFormField(
                                  keyboardType: TextInputType.name,
                                  onChanged: (value) => company = value.trim(),
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.black),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Enter Community",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border:
                                  Border.all(color: Colors.black, width: 0.1),
                              borderRadius: BorderRadius.circular(12)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(width: 18),
                              Image.asset('assets/images/building.png',
                                  width: 20, height: 20),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.7,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                // decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.black, width: 0.1), borderRadius: BorderRadius.circular(12)),
                                child: TextFormField(
                                  keyboardType: TextInputType.name,
                                  onChanged: (value) => company = value.trim(),
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.black),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Enter Company name",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration: const BoxDecoration(
                        color: Color(0xff12A4DB),
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: TextButton(
                      onPressed: () async {
                        setState(() => loading = true); /*register();*/
                      },
                      child: const Text('Register',
                          style: TextStyle(color: Colors.white, fontSize: 17)),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.12),
                  Container(
                    // color: Colors.red,
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Powered & Maintenance By:-',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black87, fontSize: 12),
                        ),
                        Text('FSL Software Technologies Limited',
                            style:
                                TextStyle(color: Colors.black87, fontSize: 12))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
