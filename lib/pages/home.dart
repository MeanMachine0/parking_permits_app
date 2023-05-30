import 'package:flutter/material.dart';
import 'package:parking_permits_app/models/permits_model.dart';
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
  PermitsModel? permits;

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
      permits = tokens.isEmpty
          ? null
          : await Api().getPermits(tokens[1], tokens[2], tokens[3]);
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: const Text('Home'),
        actions: tokens.isEmpty
            ? [
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    final result = await Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const Login())) ??
                        [];
                    if (result) {
                      getData();
                    }
                  },
                  child: const Text('Login'),
                ),
              ]
            : [
                ElevatedButton(
                  onPressed: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.clear();
                    setState(() {
                      tokens = [];
                      permits = null;
                    });
                  },
                  child: const Text('Logout'),
                ),
              ],
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : permits == null
                ? Text(
                    tokens.isEmpty
                        ? 'You are not logged in.'
                        : '${tokens[0]} ${tokens[1]} ${tokens[2]} ${tokens[3]}',
                  )
                : Text('${permits!.vehicleVrms}'),
      ),
    );
  }
}
