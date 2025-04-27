import 'package:flutter/material.dart';


class DeviceScreen extends StatefulWidget {
  const DeviceScreen({super.key});

  @override
  State<DeviceScreen> createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<DeviceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Column(

        children: [
          if(true) FloatingActionButton(onPressed: (){},
            child: Icon(Icons.save),
          ),
          FloatingActionButton(
            onPressed: (){
             },
            child: Icon(Icons.logout),
          ),
        ],
        )
      );
  }
}
