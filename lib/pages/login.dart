import 'package:flutter/material.dart';
import 'package:parking_permits_app/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final loginFormKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  bool hasAuthenticationCookies = false;
  String? certReferralUrl;
  String? wctx;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Api api = Api();
    List<String?> parts = await api.login();
    certReferralUrl = parts[0];
    wctx = parts[1];
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Login')),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Form(
              key: loginFormKey,
              autovalidateMode: AutovalidateMode.disabled,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.visiblePassword,
                    validator: (inpEmail) {
                      if (inpEmail == '') {
                        return 'Please enter a username.';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      label: Text(
                        'Email',
                        style: TextStyle(color: Colours.lightGray),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(controller: passwordController)
                ],
              )),
        ));
  }
}
