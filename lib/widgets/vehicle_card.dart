import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(labelText: 'Note'),
                      controller: TextEditingController(text: _vehicle.note),
                      onSubmitted: (newNote) async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        await prefs.setString(_vehicle.id.toString(), newNote);
                      },
                    ),
                  )
                ],
              ),
              Row(
                children: [Text(_vehicle.vrm)],
              ),
              Row(
                children: [
                  Text(
                    _vehicle.id.toString(),
                  ),
                ],
              )
            ],
          )),
    );
  }
}
