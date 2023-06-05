import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  bool isLoading = false;
  bool? hasSettings;
  bool detailedView = false;

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
    hasSettings = prefs.getBool('hasSettings');
    if (hasSettings == null) {
      await prefs.setBool('detailedView', false);
      await prefs.setBool('hasSettings', true);
    } else {
      detailedView = prefs.getBool('detailedView')!;
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
          : Column(
              children: [
                CheckboxListTile(
                  title: const Text('Detailed View'),
                  value: detailedView,
                  onChanged: (newValue) async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setBool('detailedView', newValue!);
                    setState(() {
                      detailedView = !detailedView;
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
                    },
                    child: const Text(
                      'Delete user data',
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
