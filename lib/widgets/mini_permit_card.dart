import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../models/mini_permit_model.dart';

class MiniPermitCard extends StatelessWidget {
  const MiniPermitCard({super.key, required MiniPermitModel miniPermit})
      : _miniPermit = miniPermit;

  final MiniPermitModel _miniPermit;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Animate(
          effects: const [FadeEffect()],
          child: Column(
            children: [
              Row(
                children: [Text(_miniPermit.permitType)],
              ),
              Row(
                children: [Text(_miniPermit.permitNumber)],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
