import 'package:flutter/material.dart';

import '../models/permit_model.dart';

class VehicleCard extends StatelessWidget {
  const VehicleCard({
    super.key,
    required Vehicle vehicle,
    required bool isSelected,
    required Function(Vehicle, String) func,
  })  : _vehicle = vehicle,
        _isSelected = isSelected,
        _func = func;

  final Vehicle _vehicle;
  final bool _isSelected;
  final Function(Vehicle, String) _func;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: [
                  Text(_vehicle.vrm,
                      style: const TextStyle(
                        fontFamily: 'Courier New',
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      )),
                  if (_vehicle.note != '') Text(' - ${_vehicle.note}'),
                  if (_vehicle.isActive) const SizedBox(width: 4),
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
                Row(children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(labelText: 'Note'),
                      controller: TextEditingController(text: _vehicle.note),
                      onSubmitted: (newNote) async {
                        _func(_vehicle, newNote);
                      },
                    ),
                  ),
                ]),
              // Row(
              //   children: [
              //     Text(
              //       _vehicle.id.toString(),
              //     ),
              //   ],
              // ),
            ],
          )),
    );
  }
}
