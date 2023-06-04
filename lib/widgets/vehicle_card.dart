import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../models/permit_model.dart';

class VehicleCard extends StatelessWidget {
  const VehicleCard({
    super.key,
    required Vehicle vehicle,
  }) : _vehicle = vehicle;

  final Vehicle _vehicle;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              // Row(
              //   children: [
              //     Expanded(
              //       child: TextField(
              //         decoration: const InputDecoration(labelText: 'Note'),
              //         controller: TextEditingController(text: _vehicle.note),
              //         onSubmitted: (newNote) async {
              //           SharedPreferences prefs =
              //               await SharedPreferences.getInstance();
              //           await prefs.setString(_vehicle.id.toString(), newNote);
              //         },
              //       ),
              //     )
              //   ],
              // ),
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
