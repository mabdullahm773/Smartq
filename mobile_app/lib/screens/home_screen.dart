import 'package:flutter/material.dart';
import 'package:tappo/screens/device_screen.dart';
import 'package:tappo/screens/login_screen.dart';
import 'package:tappo/screens/profile_screen.dart';
import 'package:tappo/services/auth_service.dart';
import 'package:tappo/services/user_manager_service.dart';

import '../api/device_api.dart';
import '../services/screen_size_service.dart';
import '../widgets/appbar_widget.dart';
import '../widgets/device_card.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    _loadProfileImage();
    _checkRelayStatus();
    // TODO: implement initState
    super.initState();
  }
  Future<void> _loadProfileImage() async {
    await UserManager().refreshProfileImage();
    setState(() {});
  }
  void _checkRelayStatus() async {
    print("00000000000000000000000000000000000000000000000000000");
    Relay relay = await fetchRelayById(1);
    print("111111111111111111111111111111111111111111111111111111");
    print("Relay ID: ${relay.id}");
    print("Name: ${relay.deviceName}");
    print("Is ON? ${relay.relayStatus}");
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          CustomAppBar(Title: "IoT Devices", BackButton: false, ProfileIcon: true,),
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20),
                DeviceCard(deviceName: 'My Device',status:'ON',deviceIcon: Icons.devices),
              ]
            ),
          ),
        ],
      ),
    );
  }
}
