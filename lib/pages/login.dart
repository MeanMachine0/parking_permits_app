import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:parking_permits_app/api.dart';

import '../constants.dart';
import '../instances.dart';
import '../variables.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  final loginFormKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController(),
      passwordController = TextEditingController();
  bool hasAuthenticationCookies = false,
      passVis = true,
      displayLoginError = false;
  String? password;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    if (mounted) {
      setState(() {
        Variables.isLoading = true;
      });
      Variables.tokens = Instances.prefs.getStringList('tokens') ?? [];
      Variables.parkingEmail = Instances.prefs.getString('parkingEmail');
      if (Variables.parkingEmail != null) {
        if (Variables.useBioOrLocalAuth) {
          bool authenticated = await Instances.localAuth.authenticate(
              localizedReason: 'Login as ${Variables.parkingEmail}',
              options: const AuthenticationOptions());
          if (authenticated) {
            var secureStorage = const FlutterSecureStorage();
            password = await secureStorage.read(key: 'password');
            login(Variables.parkingEmail!, password!);
          }
        }
      }
      if (mounted) {
        setState(() {
          emailController.text = Variables.parkingEmail ?? '';
          Variables.isLoading = false;
        });
      }
    }
  }

  void login(String email, String password) async {
    if (mounted) {
      setState(() {
        Variables.isLoading1 = true;
      });
      await Api().login(email, password);
      if (Variables.tokens.isNotEmpty) {
        await Instances.prefs.setStringList('tokens', Variables.tokens);
        await Instances.prefs.setString('parkingEmail', email);
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
        Variables.isLoading1 = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (Variables.tokens.isEmpty) Variables.parkingEmail = null;
        return !(Variables.isLoading || Variables.isLoading1);
      },
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Login'),
            automaticallyImplyLeading:
                !(Variables.isLoading || Variables.isLoading1),
          ),
          body: Variables.isLoading || Variables.isLoading1
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Variables.tokens.isNotEmpty
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
                                if (displayLoginError)
                                  const SizedBox(height: 20),
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
                                      style:
                                          TextStyle(color: Colours.lightGray),
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
                                      style:
                                          TextStyle(color: Colours.lightGray),
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
                    )),
    );
  }
}
