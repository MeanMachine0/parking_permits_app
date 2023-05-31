import 'package:flutter/material.dart';
import 'package:parking_permits_app/models/mini_permit_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api.dart';
import 'login.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLoading = false;
  List<String> tokens = [];
  List permitData = [];
  DateTime? expiry;

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
      Duration buffer = const Duration(seconds: 10);
      DateTime expiry =
          tokens.isNotEmpty ? DateTime.parse(tokens.last) : DateTime.now();
      permitData = tokens.isEmpty ||
              DateTime.now().add(buffer).toUtc().isAfter(expiry)
          ? []
          : await Api().getMiniPermits(tokens[1], tokens[2], tokens[3], true);
      if (permitData.isEmpty) {
        logout();
      }
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    setState(() {
      tokens.clear();
      permitData.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: const Text('Home'),
        actions: tokens.isEmpty
            ? [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });
                      await Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => const Login())) ??
                          [];
                      getData();
                    },
                    child: const Text('Login'),
                  ),
                ),
              ]
            : [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ElevatedButton(
                    onPressed: () async {
                      logout();
                    },
                    child: const Text('Logout'),
                  ),
                ),
              ],
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : permitData.isEmpty
                ? Text(
                    tokens.isEmpty
                        ? 'You are not logged in.'
                        : '${tokens[0]} ${tokens[1]} ${tokens[2]} ${tokens[3]}',
                  )
                : Text('${permitData[1].vehicles[1]}'),
      ),
    );
  }
}
