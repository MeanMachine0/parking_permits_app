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
  bool failure = false;

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
      bool detailedView = prefs.getBool('detailedView') ?? false;
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
      } else if (permitData.isNotEmpty && permitData[0] == false) {
        failure = true;
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
      miniPermit = null;
      permit = null;
      miniPermits.clear();
      selectedIndex = -1;
      failure = false;
    });
  }

  void updateVehicleNoteCallback(Vehicle vehicle, String newNote) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('${vehicle.id}Note', newNote);
    setState(() {
      vehicle.note = newNote;
    });
  }

  void assignPermitCallback(Vehicle newActiveVehicle) async {
    setState(() {
      isLoading = true;
    });
    activeVehicle!.isActive = false;
    bool success = await Api().assignPermit(
      permit!.id.toString(),
      newActiveVehicle.id.toString(),
      tokens[1],
      tokens[2],
      tokens[3],
    );
    if (success) {
      activeVehicle = newActiveVehicle;
      selectedIndex = -1;
    }
    setState(() {
      activeVehicle!.isActive = true;
      isLoading = false;
    });
  }

  void editVehicleVrmCallback(Vehicle oldVehicle, String newVehicleVrm) async {
    setState(() {
      isLoading = true;
    });
    bool success = await Api().editVehicleVrm(
      permit!.id.toString(),
      oldVehicle.id.toString(),
      newVehicleVrm,
      tokens[1],
      tokens[2],
      tokens[3],
    );
    if (success) {
      oldVehicle.vrm = newVehicleVrm;
    }
    selectedIndex = -1;
    setState(() {
      isLoading = false;
    });
  }

  void toggleVehicleIsFavouriteCallback(Vehicle vehicle) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool wasFavourite = vehicle.isFavourite;
    bool isFavourite = !wasFavourite;
    await prefs.setBool('${vehicle.id}IsFavourite', isFavourite);
    vehicle.isFavourite = isFavourite;
    Vehicle.sortByIsFavourite(permit!.vehicles);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: permit?.address.pafAddress.buildingName == '' &&
                permit?.address.street != ''
            ? Text('${permit?.address.number} ${permit?.address.street}')
            : permit?.address.pafAddress.buildingName != null
                ? Text(permit!.address.pafAddress.buildingName)
                : const Text('Home'),
        scrolledUnderElevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ElevatedButton(
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });
                if (tokens.isEmpty) {
                  await Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const Login())) ??
                      [];
                  getData();
                } else {
                  logout();
                }
                if (mounted) {
                  setState(() {
                    isLoading = false;
                  });
                }
              },
              child: Text(tokens.isEmpty ? 'Login' : 'Logout'),
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
                  ),
                )
              : failure
                  ? const Center(
                      child: Text(
                        'You have no permits to view or an error occurred whilst attempting to retreive them.',
                        textAlign: TextAlign.center,
                      ),
                    )
                  : permit != null
                      ? Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                          child: Column(
                            children: [
                              Text(
                                'Permit assigned to ${activeVehicle!.vrm}${activeVehicle!.note != '' ? ' - ${activeVehicle!.note}' : ''}',
                                textAlign: TextAlign.center,
                              ),
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
                                          assignPermit: assignPermitCallback,
                                          editVehicleVrm:
                                              editVehicleVrmCallback,
                                          toggleVehicleIsFavourite:
                                              toggleVehicleIsFavouriteCallback,
                                        ),
                                        onTap: () {
                                          if (selectedIndex == index) {
                                            setState(() {
                                              selectedIndex = -1;
                                            });
                                          } else {
                                            setState(() {
                                              selectedIndex = index;
                                            });
                                          }
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
                            return const SizedBox.shrink();
                          },
                        ),
    );
  }
}
