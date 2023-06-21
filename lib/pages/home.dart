import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:parking_permits_app/models/mini_permit_model.dart';

import '../api.dart';
import '../constants.dart';
import '../functions.dart';
import '../instances.dart';
import '../models/permit_model.dart';
import '../variables.dart';
import '../widgets/mini_permit_card.dart';
import '../widgets/vehicle_card.dart';
import 'login.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  bool failure = false, firstPass = true;
  bool? addVehicleFailure;
  List<String> orderedVehicleIds = [];
  late List permitData;
  PermitModel? permit;
  List<MiniPermitModel> miniPermits = [];
  late DateTime expiry;
  Vehicle? activeVehicle;
  int selectedIndex = -1;
  String? message;

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
      await Instances.googleSignIn.isSignedIn().then(
        (bool value) async {
          if (!value) {
            await Functions.silentSignIn();
          }
        },
      );
      Duration buffer = const Duration(minutes: 30, seconds: 10);
      DateTime expiry = Variables.tokens.isNotEmpty
          ? DateTime.parse(Variables.tokens.last)
          : DateTime.now();
      permitData = Variables.tokens.isEmpty ||
              DateTime.now().add(buffer).toUtc().isAfter(expiry)
          ? []
          : await Api().getMiniPermits(
              !Variables.useDetailedView,
              Variables.isReorderable,
            );
      if (permitData.isEmpty && Variables.tokens.isNotEmpty) {
        logout();
        message = "Your session has expired; please login again.";
      } else if (permitData.isNotEmpty && permitData[0] == false) {
        failure = true;
      } else if (permitData.isNotEmpty && !Variables.useDetailedView) {
        permit = permitData[1];
        activeVehicle =
            permit!.vehicles.firstWhere((vehicle) => vehicle.isActive == true);
      } else if (permitData.isNotEmpty) {
        miniPermits = permitData as List<MiniPermitModel>;
      }
      if (mounted) {
        setState(() {
          Variables.isLoading = false;
          Variables.isLoading1 = false;
        });
      }
    }
  }

  void logout() async {
    Variables.tokens.clear();
    permitData.clear();
    permit = null;
    miniPermits.clear();
    selectedIndex = -1;
    failure = false;
    addVehicleFailure = null;
    message = null;
    await Instances.prefs.remove('tokens');
    setState(() {});
  }

  void updateVehicleNoteCallback(Vehicle vehicle, String newNote) async {
    await Functions.setOrUpdateFirestore(
        'vehicles', 'vehicles.${vehicle.id}.note', newNote);
    await Instances.prefs.setString('${vehicle.id}Note', newNote);
    setState(() {
      vehicle.note = newNote;
    });
  }

  void assignPermitCallback(Vehicle newActiveVehicle) async {
    setState(() {
      Variables.isLoading = true;
    });
    activeVehicle?.isActive = false;
    bool success = await Api()
        .assignPermit(permit!.id.toString(), newActiveVehicle.id.toString());
    if (success) {
      activeVehicle = newActiveVehicle;
      selectedIndex = -1;
    }
    setState(() {
      activeVehicle!.isActive = true;
      Variables.isLoading = false;
    });
  }

  void editVehicleVrmCallback(Vehicle oldVehicle, String newVehicleVrm) async {
    setState(() {
      Variables.isLoading = true;
    });
    bool success = await Api().editVehicleVrm(
        permit!.id.toString(), oldVehicle.id.toString(), newVehicleVrm);
    if (success) {
      oldVehicle.vrm = newVehicleVrm;
      if (!Variables.isReorderable) Vehicle.sortByIsFavourite(permit!.vehicles);
      oldVehicle.message = 'Success!';
      selectedIndex = permit!.vehicles.indexOf(oldVehicle);
    } else {
      oldVehicle.message = 'Failed to edit vrm!';
    }
    setState(() {
      Variables.isLoading = false;
    });
  }

  void toggleVehicleIsFavouriteCallback(
      Vehicle vehicle, bool isExpanded) async {
    bool isFavourite = !vehicle.isFavourite;
    await Functions.setOrUpdateFirestore(
        'vehicles', 'vehicles.${vehicle.id}.isFavourite', isFavourite);
    await Instances.prefs.setBool('${vehicle.id}IsFavourite', isFavourite);
    vehicle.isFavourite = isFavourite;
    if (!Variables.isReorderable) Vehicle.sortByIsFavourite(permit!.vehicles);
    if (isExpanded) selectedIndex = permit!.vehicles.indexOf(vehicle);
    setState(() {});
  }

  GestureDetector interactiveVehicleCard(Vehicle vehicle, int index) {
    return GestureDetector(
      child: VehicleCard(
        vehicle: vehicle,
        isSelected: index == selectedIndex,
        permitHasNotExpired: !permit!.isExpired,
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
    return WillPopScope(
      onWillPop: () async {
        if (!firstPass && miniPermits.isEmpty && Variables.tokens.isNotEmpty) {
          selectedIndex = -1;
          permit = null;
          addVehicleFailure = null;
          firstPass = true;
          getData();
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading:
              !firstPass && miniPermits.isEmpty && Variables.tokens.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        selectedIndex = -1;
                        permit = null;
                        addVehicleFailure = null;
                        firstPass = true;
                        getData();
                      },
                      icon: const Icon(Icons.arrow_back))
                  : null,
          title: miniPermits.isNotEmpty
              ? const Text('My Permits')
              : !firstPass
                  ? Text(permit?.permitNumber ?? 'Permit not found')
                  : permit?.address.pafAddress.buildingName == '' &&
                          permit?.address.street != ''
                      ? Text(
                          '${permit?.address.number} ${permit?.address.street}')
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
                    Variables.isLoading = true;
                  });
                  if (Variables.tokens.isEmpty) {
                    bool success = await Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const Login())) ??
                        false;
                    if (success && mounted) {
                      setState(() {
                        Variables.isLoading1 = true;
                      });
                      getData();
                    } else {
                      setState(() {
                        Variables.isLoading = false;
                      });
                    }
                  } else {
                    logout();
                    if (mounted) {
                      Variables.isLoading = false;
                      setState(() {});
                    }
                  }
                },
                child: Text(Variables.tokens.isEmpty ? 'Login' : 'Logout'),
              ),
            ),
          ],
        ),
        body: Variables.isLoading || Variables.isLoading1
            ? const Center(child: CircularProgressIndicator())
            : permitData.isEmpty && permit == null
                ? Animate(
                    effects: const [
                      FadeEffect(),
                    ],
                    child: Center(
                      child: Text(
                        message ??
                            (Variables.tokens.isEmpty
                                ? 'You are not logged in.'
                                : 'Logged in as ${Variables.parkingEmail}'),
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
                            padding: const EdgeInsets.symmetric(horizontal: 10),
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
                                        activeVehicle != null
                                            ? Text(
                                                'Permit assigned to ${activeVehicle!.vrm}${(activeVehicle!.note != null && activeVehicle!.note!.replaceAll(' ', '') != '') ? ' - ${activeVehicle!.note}' : ''}',
                                              )
                                            : const Text(
                                                'Permit is not currently assigned to a vehicle.'),
                                      ],
                                    ),
                                  ),
                                  if (!permit!.isExpired &&
                                      permit!.vehicles.length < 20)
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
                                                  Variables.isLoading = true;
                                                });
                                                int numVehiclesBefore =
                                                    permit!.vehicles.length;
                                                permit = await Api()
                                                        .addVehicleToPermit(
                                                            vrm
                                                                .replaceAll(
                                                                    ' ', '')
                                                                .toUpperCase(),
                                                            permit!,
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
                                                    Variables.isLoading = false;
                                                  });
                                                }
                                              },
                                            ),
                                          ),
                                          if (addVehicleFailure != null)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: Text(
                                                addVehicleFailure!
                                                    ? 'Failed!'
                                                    : 'Success!',
                                                style: TextStyle(
                                                  color: addVehicleFailure!
                                                      ? Colours.red
                                                      : Colours.green,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  const SizedBox(height: 10),
                                  Expanded(
                                    child: Variables.isReorderable
                                        ? ReorderableListView(
                                            onReorder:
                                                (oldIndex, newIndex) async {
                                              setState(() {
                                                if (newIndex ==
                                                    permit!.vehicles.length +
                                                        1) {
                                                  newIndex =
                                                      permit!.vehicles.length -
                                                          1;
                                                } else if (newIndex >
                                                    oldIndex) {
                                                  newIndex--;
                                                }
                                                final Vehicle vehicle = permit!
                                                    .vehicles
                                                    .removeAt(oldIndex);
                                                permit!.vehicles
                                                    .insert(newIndex, vehicle);
                                              });

                                              for (Vehicle vehicle1
                                                  in permit!.vehicles) {
                                                vehicle1.index = permit!
                                                    .vehicles
                                                    .indexOf(vehicle1);
                                              }
                                              orderedVehicleIds = permit!
                                                  .vehicles
                                                  .map((vehicle) =>
                                                      vehicle.id.toString())
                                                  .toList();
                                              await Functions.setOrUpdateFirestore(
                                                  'permitIdToOrderedVehicleIds',
                                                  'permitIdToOrderedVehicleIds.${permit!.id.toString()}',
                                                  orderedVehicleIds);
                                              await Instances.prefs
                                                  .setStringList(
                                                      permit!.id.toString(),
                                                      orderedVehicleIds);
                                              if (mounted) {
                                                setState(() {
                                                  if (selectedIndex ==
                                                      oldIndex) {
                                                    selectedIndex = newIndex;
                                                  }
                                                });
                                              }
                                            },
                                            footer: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 4),
                                              child: Center(
                                                child: ElevatedButton(
                                                  onPressed: () async {
                                                    Vehicle.sortByIsFavourite(
                                                        permit!.vehicles);
                                                    await Functions.setOrUpdateFirestore(
                                                        'permitIdToOrderedVehicleIds',
                                                        'permitIdToOrderedVehicleIds.${permit!.id.toString()}',
                                                        permit!.vehicles
                                                            .map((vehicle) =>
                                                                vehicle.id
                                                                    .toString())
                                                            .toList());

                                                    Instances.prefs.remove(
                                                        'orderedVehicleIds');
                                                    setState(() {});
                                                  },
                                                  child: const Text(
                                                      'Reset custom ordering'),
                                                ),
                                              ),
                                            ),
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
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              children: [
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: miniPermits.length,
                                    itemBuilder: (content, index) {
                                      return Animate(
                                        effects: const [SlideEffect()],
                                        child: GestureDetector(
                                          child: MiniPermitCard(
                                            miniPermit: miniPermits[index],
                                            dateFormat: Variables.dateFormat,
                                          ),
                                          onTap: () async {
                                            setState(() {
                                              Variables.isLoading = true;
                                            });
                                            orderedVehicleIds = Variables
                                                    .isReorderable
                                                ? Instances.prefs.getStringList(
                                                        miniPermits[index]
                                                            .id
                                                            .toString()) ??
                                                    []
                                                : [];
                                            permit = await Api().getPermit(
                                              miniPermits[index].id.toString(),
                                              orderedVehicleIds.isNotEmpty,
                                            );
                                            if (permit == null ||
                                                permit!.vehicles.isNotEmpty) {
                                              try {
                                                activeVehicle = permit!.vehicles
                                                    .firstWhere((vehicle) =>
                                                        vehicle.isActive ==
                                                        true);
                                              } catch (e) {
                                                activeVehicle = null;
                                              }
                                            }
                                            miniPermits.clear();
                                            if (mounted) {
                                              setState(() {
                                                firstPass = false;
                                                Variables.isLoading = false;
                                              });
                                            }
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
      ),
    );
  }
}
