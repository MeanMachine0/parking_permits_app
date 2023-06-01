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
          padding: const EdgeInsets.all(5),
          child: Column(
            children: [
              Row(
                children: [Text(_vehicle.note)],
              ),
              Row(
                children: [Text(_vehicle.vrm)],
              ),
            ],
          )),
    );
  }
}
