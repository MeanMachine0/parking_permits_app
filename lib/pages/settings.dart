import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  bool isLoading = false, isReorderable = false;
  bool? detailedView;
  List<String>? tokens;
  String? email;

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
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    detailedView = prefs.getBool('detailedView');
    isReorderable = prefs.getBool('isReorderable') ?? false;
    tokens = prefs.getStringList('tokens');
    if (tokens != null) {
      email = prefs.getString('email');
    }
    if (detailedView == null) {
      await prefs.setBool('detailedView', false);
      detailedView = false;
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
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Animate(
              effects: const [
                FadeEffect(),
              ],
              child: Column(
                children: [
                  CheckboxListTile(
                    title: const Text('Detailed View'),
                    value: detailedView,
                    onChanged: (newValue) async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setBool('detailedView', newValue!);
                      setState(() {
                        detailedView = !detailedView!;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('Reorderable Vehicles'),
                    value: isReorderable,
                    onChanged: (newValue) async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setBool('isReorderable', newValue!);
                      setState(() {
                        isReorderable = !isReorderable;
                      });
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: ElevatedButton(
                      onPressed: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        await prefs.clear();
                        setState(() {
                          detailedView = false;
                          isReorderable = false;
                          tokens = null;
                          email = null;
                        });
                      },
                      child: const Text(
                        'Delete user data',
                      ),
                    ),
                  ),
                  Text(email ?? 'Not logged in'),
                ],
              ),
            ),
    );
  }
}
