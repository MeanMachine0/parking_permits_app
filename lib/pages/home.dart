import 'package:flutter/material.dart';
import 'package:parking_permits_app/models/mini_permit_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api.dart';
import '../models/permit_model.dart';
import '../widgets/vehicle_card.dart';
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
  MiniPermitModel? miniPermit;
  PermitModel? permit;
  DateTime? expiry;
  Vehicle? activeVehicle;

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
      Duration buffer = const Duration(minutes: 30, seconds: 10);
      DateTime expiry =
          tokens.isNotEmpty ? DateTime.parse(tokens.last) : DateTime.now();
      permitData = tokens.isEmpty ||
              DateTime.now().add(buffer).toUtc().isAfter(expiry)
          ? []
          : await Api().getMiniPermits(tokens[1], tokens[2], tokens[3], true);
      if (permitData.isEmpty && tokens.isNotEmpty) {
        logout();
      } else if (permitData.isNotEmpty) {
        miniPermit = permitData[0];
        permit = permitData[1];
        activeVehicle =
            permit!.vehicles.firstWhere((vehicle) => vehicle.isActive == true);
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
    await prefs.remove('tokens');
    setState(() {
      tokens.clear();
      permitData.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : permitData.isEmpty
              ? Center(
                  child: Text(
                  tokens.isEmpty
                      ? 'You are not logged in.'
                      : '${tokens[0]} ${tokens[1]} ${tokens[2]} ${tokens[3]}',
                ))
              : permit != null
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                      child: ListView.builder(
                        itemCount: permit!.vehicles.length,
                        itemBuilder: (content, index) {
                          return VehicleCard(vehicle: permit!.vehicles[index]);
                        },
                      ),
                    )
                  // Undecided:
                  : ListView.builder(
                      itemCount: miniPermit!.vehicleVrms.length,
                      itemBuilder: (content, index) {
                        return null;
                      },
                    ),
    );
  }
}
