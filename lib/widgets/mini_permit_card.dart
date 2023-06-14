import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

import '../constants.dart';
import '../models/mini_permit_model.dart';

class MiniPermitCard extends StatelessWidget {
  const MiniPermitCard({
    super.key,
    required MiniPermitModel miniPermit,
    required String dateFormat,
  })  : _miniPermit = miniPermit,
        _dateFormat = dateFormat;

  final MiniPermitModel _miniPermit;
  final String _dateFormat;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Animate(
          effects: const [FadeEffect()],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_miniPermit.permitNumber),
              Text(_miniPermit.permitType),
              Text(
                  '${_miniPermit.isExpired ? 'Expired on' : 'Valid until'} ${DateFormat(_dateFormat).format(_miniPermit.expiryDate)}',
                  style: TextStyle(
                    color: _miniPermit.isExpired ? Colours.red : Colours.green,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
