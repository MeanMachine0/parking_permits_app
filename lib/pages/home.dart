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
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  bool isLoading = false;
  List<String> tokens = [];
  List permitData = [];
  MiniPermitModel? miniPermit;
  PermitModel? permit;
  List<MiniPermitModel> miniPermits = [];
  DateTime? expiry;
  Vehicle? activeVehicle;
  int selectedIndex = -1;

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
      bool detailedView = prefs.getBool('detailedView') ?? true;
      tokens = prefs.getStringList('tokens') ?? [];
      Duration buffer = const Duration(minutes: 30, seconds: 10);
      DateTime expiry =
          tokens.isNotEmpty ? DateTime.parse(tokens.last) : DateTime.now();
      permitData = tokens.isEmpty ||
              DateTime.now().add(buffer).toUtc().isAfter(expiry)
          ? []
          : await Api()
              .getMiniPermits(tokens[1], tokens[2], tokens[3], !detailedView);
      if (permitData.isEmpty && tokens.isNotEmpty) {
        logout();
      } else if (permitData.isNotEmpty && !detailedView) {
        miniPermit = permitData[0];
        permit = permitData[1];
        activeVehicle =
            permit!.vehicles.firstWhere((vehicle) => vehicle.isActive == true);
      } else if (permitData.isNotEmpty) {
        miniPermits = permitData as List<MiniPermitModel>;
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

  void updateVehicleNoteCallback(Vehicle vehicle, String newNote) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(vehicle.id.toString(), newNote);
    setState(() {
      vehicle.note = newNote;
    });
  }

  void assignToPermitCallback(Vehicle newActiveVehicle) async {
    setState(() {
      isLoading = true;
    });
    activeVehicle!.isActive = false;
    await Api().assignToPermit(
      permit!.id.toString(),
      newActiveVehicle.id.toString(),
      tokens[1],
      tokens[2],
      tokens[3],
    );
    activeVehicle = newActiveVehicle;
    setState(() {
      activeVehicle!.isActive = true;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        scrolledUnderElevation: 0,
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
                      child: Column(
                        children: [
                          Text(
                              'Permit assigned to ${activeVehicle!.vrm}${activeVehicle!.note != '' ? ' - ${activeVehicle!.note}' : ''}'),
                          //   onChanged: (newActiveVehicleId) async {
                          //     setState(() {
                          //       isLoading = true;
                          //     });
                          //     await Api().setActiveVehicle(
                          //       permit!.id.toString(),
                          //       newActiveVehicleId!,
                          //       tokens[1],
                          //       tokens[2],
                          //       tokens[3],
                          //     );
                          //     if (mounted) {
                          //       setState(() {
                          //         activeVehicleId = newActiveVehicleId;
                          //         isLoading = false;
                          //       });
                          //     }
                          //   },
                          // ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: ListView.builder(
                              itemCount: permit!.vehicles.length,
                              itemBuilder: (content, index) {
                                return GestureDetector(
                                    child: VehicleCard(
                                      vehicle: permit!.vehicles[index],
                                      isSelected: index == selectedIndex,
                                      updateVehicleNote:
                                          updateVehicleNoteCallback,
                                      assignToPermit: assignToPermitCallback,
                                    ),
                                    onTap: () {
                                      setState(() {
                                        selectedIndex = index;
                                      });
                                    });
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: miniPermits.length,
                      itemBuilder: (content, index) {
                        // Coming soon:
                        return null;
                      },
                    ),
    );
  }
}
