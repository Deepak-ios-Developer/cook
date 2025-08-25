import 'package:flutter/material.dart';

class CommonToggleSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color activeColor;
  final Color inactiveColor;

  const CommonToggleSwitch({
    Key? key,
    required this.value,
    required this.onChanged,
    required this.activeColor,
    this.inactiveColor = Colors.grey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: value,
      onChanged: onChanged,
      activeColor: activeColor,
      inactiveThumbColor: inactiveColor,
      inactiveTrackColor: inactiveColor.withOpacity(0.4),
    );
  }
}
