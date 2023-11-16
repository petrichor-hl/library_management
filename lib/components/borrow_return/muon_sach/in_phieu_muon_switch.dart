import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class InPhieuMuonSwitch extends StatefulWidget {
  const InPhieuMuonSwitch({
    super.key,
    required this.onSwitchChanged,
  });

  final void Function(bool) onSwitchChanged;

  @override
  State<InPhieuMuonSwitch> createState() => _InPhieuMuonSwitchState();
}

class _InPhieuMuonSwitchState extends State<InPhieuMuonSwitch> {
  bool _isInPhieuMuon = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          'In Phiếu mượn',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Gap(30),
        Switch(
          value: _isInPhieuMuon,
          onChanged: (value) {
            setState(() => _isInPhieuMuon = value);
          },
        ),
      ],
    );
  }
}
