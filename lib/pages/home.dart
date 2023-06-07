import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:parking_permits_app/models/mini_permit_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api.dart';
import '../constants.dart';
import '../models/permit_model.dart';
import '../widgets/vehicle_card.dart';
import 'login.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  bool isLoading = false, failure = false, isReorderable = false;
  bool? addVehicleFailure;
  List<String> tokens = [], orderedVehicleIds = [];
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
      bool detailedView = prefs.getBool('detailedView') ?? false;
      isReorderable = prefs.getBool('isReorderable') ?? false;
      if (isReorderable) {
        orderedVehicleIds = prefs.getStringList('orderedVehicleIds') ?? [];
      }
      tokens = prefs.getStringList('tokens') ?? [];
      Duration buffer = const Duration(minutes: 30, seconds: 10);
      DateTime expiry =
          tokens.isNotEmpty ? DateTime.parse(tokens.last) : DateTime.now();
      permitData =
          tokens.isEmpty || DateTime.now().add(buffer).toUtc().isAfter(expiry)
              ? []
              : await Api().getMiniPermits(
                  tokens[1],
                  tokens[2],
                  tokens[3],
                  !detailedView,
                  orderedVehicleIds.isNotEmpty,
                );
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
      if (!isReorderable) Vehicle.sortByIsFavourite(permit!.vehicles);
    }
    selectedIndex = -1;
    setState(() {
      isLoading = false;
    });
  }

  void toggleVehicleIsFavouriteCallback(
      Vehicle vehicle, bool isExpanded) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool wasFavourite = vehicle.isFavourite;
    bool isFavourite = !wasFavourite;
    await prefs.setBool('${vehicle.id}IsFavourite', isFavourite);
    vehicle.isFavourite = isFavourite;
    if (!isReorderable) Vehicle.sortByIsFavourite(permit!.vehicles);
    if (isExpanded) selectedIndex = permit!.vehicles.indexOf(vehicle);
    setState(() {});
  }

  GestureDetector interactiveVehicleCard(Vehicle vehicle, int index) {
    return GestureDetector(
      child: VehicleCard(
        vehicle: vehicle,
        isSelected: index == selectedIndex,
        updateVehicleNote: updateVehicleNoteCallback,
        editVehicleVrm: editVehicleVrmCallback,
        assignPermit: assignPermitCallback,
        toggleVehicleIsFavourite: toggleVehicleIsFavouriteCallback,
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
      },
    );
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
              ? Animate(
                  effects: const [
                    FadeEffect(),
                  ],
                  child: const Center(
                    child: Text(
                      'You are not logged in.',
                    ),
                  ),
                )
              : failure
                  ? Animate(
                      effects: const [
                        FadeEffect(),
                      ],
                      child: const Center(
                        child: Text(
                          'You have no permits to view or an error occurred whilst attempting to retreive them.',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : permit != null
                      ? Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                          child: Animate(
                            effects: const [
                              FadeEffect(),
                            ],
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Permit assigned to ${activeVehicle!.vrm}${activeVehicle!.note != '' ? ' - ${activeVehicle!.note}' : ''}',
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          decoration: const InputDecoration(
                                              label: Text(
                                            'Add vehicle to permit (vrm)',
                                            textAlign: TextAlign.center,
                                          )),
                                          onSubmitted: (vrm) async {
                                            setState(() {
                                              isLoading = true;
                                            });
                                            int numVehiclesBefore =
                                                permit!.vehicles.length;
                                            permit = await Api()
                                                    .addVehicleToPermit(
                                                        vrm.replaceAll(' ', ''),
                                                        permit!,
                                                        tokens[1],
                                                        tokens[2],
                                                        tokens[3],
                                                        orderedVehicleIds
                                                            .isNotEmpty) ??
                                                permit;
                                            if (numVehiclesBefore ==
                                                permit!.vehicles.length) {
                                              addVehicleFailure = true;
                                            } else {
                                              addVehicleFailure = false;
                                            }
                                            if (mounted) {
                                              setState(() {
                                                isLoading = false;
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                      if (addVehicleFailure != null)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: Text(
                                            addVehicleFailure!
                                                ? 'Failed'
                                                : 'Success',
                                            style: TextStyle(
                                              color: addVehicleFailure!
                                                  ? Colours.red
                                                  : Colors.green,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Expanded(
                                  child: isReorderable
                                      ? ReorderableListView(
                                          onReorder:
                                              (oldIndex, newIndex) async {
                                            setState(() {
                                              if (newIndex > oldIndex) {
                                                newIndex--;
                                              }
                                              final Vehicle vehicle = permit!
                                                  .vehicles
                                                  .removeAt(oldIndex);
                                              permit!.vehicles
                                                  .insert(newIndex, vehicle);
                                            });
                                            SharedPreferences prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            for (Vehicle vehicle1
                                                in permit!.vehicles) {
                                              vehicle1.index = permit!.vehicles
                                                  .indexOf(vehicle1);
                                            }
                                            orderedVehicleIds = permit!.vehicles
                                                .map((vehicle) =>
                                                    vehicle.id.toString())
                                                .toList();
                                            await prefs.setStringList(
                                                'orderedVehicleIds',
                                                orderedVehicleIds);
                                            if (mounted) {
                                              setState(() {});
                                            }
                                          },
                                          children: [
                                            for (Vehicle vehicle
                                                in permit!.vehicles)
                                              Animate(
                                                key: ValueKey(vehicle),
                                                effects: const [
                                                  SlideEffect(),
                                                ],
                                                child: interactiveVehicleCard(
                                                    vehicle,
                                                    permit!.vehicles
                                                        .indexOf(vehicle)),
                                              ),
                                          ],
                                        )
                                      : ListView.builder(
                                          itemCount: permit!.vehicles.length,
                                          itemBuilder: (content, index) {
                                            return Animate(
                                              effects: const [
                                                SlideEffect(),
                                              ],
                                              child: interactiveVehicleCard(
                                                  permit!.vehicles[index],
                                                  index),
                                            );
                                          },
                                        ),
                                ),
                              ],
                            ),
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
