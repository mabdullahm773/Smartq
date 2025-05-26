import 'package:flutter/material.dart';

class ToggleSwitch extends StatefulWidget {
  final bool isOn;
  const ToggleSwitch({super.key, required this.isOn});

  @override
  State<ToggleSwitch> createState() => _ToggleSwitchState();
}

class _ToggleSwitchState extends State<ToggleSwitch> {
  late bool isOn;
  @override
  void initState() {
    isOn = widget.isOn;
    // TODO: implement initState
    super.initState();
  }
  Widget build(BuildContext context) {
    return Switch(
        value: isOn,
        onChanged: (value){
          setState(() {
            isOn = value;
          });
        }
    );
  }
}
