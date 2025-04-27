import 'package:flutter/material.dart';
import 'package:tappo/screens/device_screen.dart';
import 'package:tappo/screens/login_screen.dart';
import 'package:tappo/screens/profile_screen.dart';
import 'package:tappo/services/auth_service.dart';
import 'package:tappo/services/user_manager_service.dart';

import '../services/screen_size_service.dart';
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
    // TODO: implement initState
    super.initState();
  }
  Future<void> _loadProfileImage() async {
    await UserManager().refreshProfileImage();
    setState(() {});
  }
  List<Map<String, dynamic>> dummyDevices = [
    {
      'deviceName': 'Smart Fan',
      'status': 'Online',
      'deviceIcon': Icons.toys_outlined,
    },
    {
      'deviceName': 'Smart Light',
      'status': 'Offline',
      'deviceIcon': Icons.lightbulb_outline,
    },
    {
      'deviceName': 'Security Camera',
      'status': 'Online',
      'deviceIcon': Icons.videocam_outlined,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE8E8D2),
      appBar: AppBar(
        backgroundColor: Color(0xFFFFA700),
        centerTitle: true,
        title: Text("Tappo", style: TextStyle(fontWeight: FontWeight.bold),),
        elevation: 4,
        shadowColor: Colors.black,
        actions: [
          // Profile Icon Button
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              child: GestureDetector(
                onTap: () =>  Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen())),
                child: CircleAvatar(
                  backgroundImage: UserManager().getProfileImageProvider(),
                ),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: dummyDevices.map((device) {
            SizedBox(
              height: Height * 0.5,);
            return Padding(
              padding: EdgeInsets.only(top: Height * 0.015, left: Width * 0.015, right: Width * 0.015),
              child: DeviceCard(
                deviceName: device['deviceName'],
                status: device['status'],
                deviceIcon: device['deviceIcon'],
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => DeviceScreen()));
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
