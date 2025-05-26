import 'package:flutter/material.dart';
import 'package:tappo/api/relay_channel.dart';
import 'package:tappo/services/user_manager_service.dart';
import '../api/api_connectivity.dart';
import '../widgets/appbar_widget.dart';
import '../widgets/device_card.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<RelayChannel> relays = [];
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
    try {
      relays = await fetchRelayChannels();
    } catch (e) {
      print('Error connecting to API or fetching data: $e');
    }
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
                DeviceCard(deviceName: 'My Device',status:'ON',deviceIcon: Icons.devices, relays: relays,),
              ]
            ),
          ),
        ],
      ),
    );
  }
}
