import 'package:flutter/material.dart';
import 'package:parking_permits_app/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  final loginFormKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  bool hasAuthenticationCookies = false;
  List<String> tokens = [];
  bool passVis = true;
  bool displayLoginError = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      tokens = prefs.getStringList('tokens') ?? [];
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void login() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Api api = Api();
      tokens = await api.login(emailController.text, passwordController.text);
      await prefs.setStringList('tokens', tokens);
      if (tokens.isNotEmpty) {
        // ignore: use_build_context_synchronously
        Navigator.pop(context, true);
      } else {
        displayLoginError = true;
      }
    }
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Login')),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : tokens.isNotEmpty
                ? const Center(
                    child: Text('Logged in.'),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Form(
                        key: loginFormKey,
                        autovalidateMode: AutovalidateMode.disabled,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (displayLoginError)
                              const Text(
                                'Invalid username and/or password.',
                                style: TextStyle(
                                  color: Colours.red,
                                ),
                              ),
                            if (displayLoginError) const SizedBox(height: 20),
                            TextFormField(
                              controller: emailController,
                              keyboardType: TextInputType.visiblePassword,
                              validator: (inpEmail) {
                                if (inpEmail == '') {
                                  return 'Please enter an email.';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                label: Text(
                                  'Email',
                                  style: TextStyle(color: Colours.lightGray),
                                ),
                                prefixIcon: Icon(Icons.email_outlined),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: passwordController,
                              keyboardType: TextInputType.visiblePassword,
                              validator: (inpPw) {
                                if (inpPw == '') {
                                  return 'Please enter a password.';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                label: const Text(
                                  'Password',
                                  style: TextStyle(color: Colours.lightGray),
                                ),
                                prefixIcon: const Icon(Icons.lock_outline),
                                suffixIcon: IconButton(
                                    icon: passVis
                                        ? const Icon(
                                            Icons.visibility_off_outlined,
                                            color: Colours.lightGray,
                                          )
                                        : const Icon(
                                            Icons.visibility_outlined,
                                            color: Colours.lightGray,
                                          ),
                                    onPressed: () => setState(() {
                                          passVis = !passVis;
                                        })),
                              ),
                              obscureText: passVis,
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () async {
                                loginFormKey.currentState!.save();
                                if (loginFormKey.currentState!.validate()) {
                                  login();
                                }
                              },
                              child: const Text('Login'),
                            ),
                          ],
                        )),
                  ));
  }
}
