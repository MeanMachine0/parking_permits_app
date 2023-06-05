import 'package:flutter/material.dart';

import '../models/permit_model.dart';

class VehicleCard extends StatelessWidget {
  const VehicleCard({
    super.key,
    required Vehicle vehicle,
    required bool isSelected,
    required Function(Vehicle, String) updateVehicleNote,
    required Function(Vehicle) assignPermit,
    required Function(Vehicle, String) editVehicleVrm,
  })  : _vehicle = vehicle,
        _isSelected = isSelected,
        _updateVehicleNote = updateVehicleNote,
        _assignPermit = assignPermit,
        _editVehicleVrm = editVehicleVrm;

  final Vehicle _vehicle;
  final bool _isSelected;
  final Function(Vehicle, String) _updateVehicleNote;
  final Function(Vehicle) _assignPermit;
  final Function(Vehicle, String) _editVehicleVrm;

  @override
  Widget build(BuildContext context) {
    return Card(
      // elevation: 3,
      child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    _vehicle.vrm,
                    style: const TextStyle(
                      fontFamily: 'Courier New',
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  if (_vehicle.note != '') Text(' - ${_vehicle.note}'),
                  Expanded(child: Container()),
                  if (_vehicle.isActive)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      color: Colors.green,
                      alignment: Alignment.centerRight,
                      child: const Text(
                        'PERMIT ASSIGNED',
                        style: TextStyle(
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    )
                ],
              ),
              if (_isSelected)
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(labelText: 'Note'),
                        controller: TextEditingController(text: _vehicle.note),
                        onSubmitted: (newNote) async {
                          _updateVehicleNote(_vehicle, newNote);
                        },
                      ),
                    ),
                  ],
                ),
              if (_isSelected)
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(labelText: 'Vrm'),
                        controller: TextEditingController(text: _vehicle.vrm),
                        onSubmitted: (newVrm) async {
                          if (newVrm.replaceAll(' ', '') != _vehicle.vrm) {
                            _editVehicleVrm(_vehicle, newVrm);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              if (_isSelected && !_vehicle.isActive)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _assignPermit(_vehicle);
                        },
                        child: const Text('Assign to permit'),
                      ),
                    ],
                  ),
                ),
            ],
          )),
    );
  }
}
