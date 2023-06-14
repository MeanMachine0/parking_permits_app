import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../constants.dart';
import '../models/permit_model.dart';

class VehicleCard extends StatelessWidget {
  const VehicleCard({
    super.key,
    required Vehicle vehicle,
    required bool isSelected,
    required bool permitHasNotExpired,
    required Function(Vehicle, String) updateVehicleNote,
    required Function(Vehicle) assignPermit,
    required Function(Vehicle, String) editVehicleVrm,
    required Function(Vehicle, bool) toggleVehicleIsFavourite,
  })  : _vehicle = vehicle,
        _isSelected = isSelected,
        _permitHasNotExpired = permitHasNotExpired,
        _updateVehicleNote = updateVehicleNote,
        _assignPermit = assignPermit,
        _editVehicleVrm = editVehicleVrm,
        _toggleVehicleIsFavourite = toggleVehicleIsFavourite;

  final Vehicle _vehicle;
  final bool _isSelected, _permitHasNotExpired;
  final Function(Vehicle, String) _updateVehicleNote, _editVehicleVrm;
  final Function(Vehicle) _assignPermit;
  final Function(Vehicle, bool) _toggleVehicleIsFavourite;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
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
                  if (_vehicle.note != null &&
                      _vehicle.note!.replaceAll(' ', '') != '')
                    Expanded(
                      child: Text(
                        ' - ${_vehicle.note}',
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  else
                    Expanded(child: Container()),
                  if (_vehicle.isActive)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      color: Colours.green,
                      alignment: Alignment.centerRight,
                      child: const Text(
                        'PERMIT ASSIGNED',
                        style: TextStyle(
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  GestureDetector(
                    onTap: () {
                      _toggleVehicleIsFavourite(_vehicle, _isSelected);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(left: _vehicle.isActive ? 6 : 0),
                      child: Icon(
                        _vehicle.isFavourite
                            ? Icons.favorite
                            : Icons.favorite_outline,
                      ),
                    ),
                  ),
                ],
              ),
              if (_isSelected)
                Animate(
                  effects: const [
                    FadeEffect(),
                  ],
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(labelText: 'Note'),
                          controller:
                              TextEditingController(text: _vehicle.note ?? ''),
                          onSubmitted: (newNote) async {
                            _updateVehicleNote(_vehicle, newNote);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              if (_isSelected && _permitHasNotExpired)
                Animate(
                  effects: const [
                    FadeEffect(),
                  ],
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(labelText: 'Vrm'),
                          controller: TextEditingController(text: _vehicle.vrm),
                          onSubmitted: (newVrm) async {
                            newVrm = newVrm.replaceAll(' ', '').toUpperCase();
                            if (newVrm != _vehicle.vrm) {
                              _editVehicleVrm(_vehicle, newVrm);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              if (_isSelected && !_vehicle.isActive && _permitHasNotExpired)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Animate(
                    effects: const [
                      FadeEffect(),
                    ],
                    child: ElevatedButton(
                      onPressed: () {
                        _assignPermit(_vehicle);
                      },
                      child: const Text('Assign permit'),
                    ),
                  ),
                ),
              if (_isSelected && _vehicle.message != null)
                Center(
                  child: Animate(
                    effects: const [FadeEffect()],
                    child: Text(
                      _vehicle.message!,
                      style: TextStyle(
                        color: _vehicle.message!.contains('Success')
                            ? Colours.green
                            : Colours.red,
                      ),
                    ),
                  ),
                ),
            ],
          )),
    );
  }
}
