import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
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
  TextEditingController emailController = TextEditingController(),
      passwordController = TextEditingController();
  bool isLoading = false,
      isLoading2 = false,
      hasAuthenticationCookies = false,
      passVis = true,
      displayLoginError = false,
      useBioAuth = false;
  List<String> tokens = [];
  String? email, password;
  LocalAuthentication? auth;

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
      email = prefs.getString('email');
      if (email != null) {
        auth = LocalAuthentication();
        await auth!.isDeviceSupported().then(
          (bioAuthSupport) {
            if (bioAuthSupport) {
              useBioAuth = prefs.getBool('useBioAuth') ?? true;
            }
          },
        );
        if (useBioAuth) {
          bool authenticated = await auth!.authenticate(
              localizedReason: 'Login as $email',
              options: const AuthenticationOptions());
          if (authenticated) {
            var secureStorage = const FlutterSecureStorage();
            password = await secureStorage.read(key: 'password');
            login(email!, password!);
          }
        }
      }
      if (mounted) {
        setState(() {
          emailController.text = email ?? '';
          isLoading = false;
        });
      }
    }
  }

  void login(String email, String password) async {
    if (mounted) {
      setState(() {
        isLoading2 = true;
      });
      tokens = await Api().login(email, password);
      if (tokens.isNotEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setStringList('tokens', tokens);
        await prefs.setString('email', email);
        var secureStorage = const FlutterSecureStorage();
        await secureStorage.write(key: 'password', value: password);
        // ignore: use_build_context_synchronously
        Navigator.pop(context, true);
      } else {
        displayLoginError = true;
      }
    }
    if (mounted) {
      setState(() {
        isLoading2 = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Login')),
        body: isLoading || isLoading2
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : tokens.isNotEmpty
                ? const Center(
                    child: Text('Logged in.'),
                  )
                : Animate(
                    effects: const [
                      FadeEffect(),
                    ],
                    child: Padding(
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
                                    login(emailController.text,
                                        passwordController.text);
                                  }
                                },
                                child: const Text('Login'),
                              ),
                            ],
                          )),
                    ),
                  ));
  }
}
