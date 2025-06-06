import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tappo/services/screen_size_service.dart';
import '../api/relay_data.dart';
import '../api/relay_model.dart';
import '../screens/device_screen.dart';

class DeviceCard extends StatefulWidget {

  const DeviceCard({super.key});

  @override
  State<DeviceCard> createState() => _DeviceCardState();
}

class _DeviceCardState extends State<DeviceCard> {
  late bool collapse;
  bool isLoading = true;
  bool reload = true;
  final RelayData relayData = RelayData();

  @override
  void initState() {
    collapse = false;
    Future.delayed(Duration(seconds: 1), (){
      reload = false;
      setState(() {});
    });
    _initializeRelays();
    super.initState();
  }

  Future<void> _initializeRelays() async {
    await relayData.loadRelays();
    setState(() {
      isLoading = false;
    });
  }

  Widget _buildRelaySwitch(int id) {
    RelayChannel relay = relayData.getRelayById(id);
    return SwitchListTile(
      title: Text(relay.deviceName ?? 'Relay $id', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17, color: Colors.teal.shade600,),),
      value: relay.relayStatus,
      onChanged: (bool value) async {
        value = !value;
        await relayData.toggleRelay(id);
        setState(() {}); // refresh UI
      },
      inactiveTrackColor: Colors.white,
      inactiveThumbColor: Colors.red.shade300,
      activeColor: Colors.teal,
    );
  }

  Widget build(BuildContext context) {
    if(reload)
      return Column(
        children: [
          SizedBox(height: Height * 0.32,),
          SpinKitCircle(color: Colors.grey, size: 65,),
          SizedBox(height: Height * 0.03,),
          Text("Loading Please Wait ....", style: TextStyle(color: Colors.grey, fontSize: 16),)
        ],
      );
    if (isLoading) {
      return Column(
        children: [
          SizedBox(height: Height * 0.3,),
          Text(
            'Something went wrong.\nPlease try again.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.redAccent.shade700, fontSize: 20, fontWeight: FontWeight.w500, letterSpacing: 0.5,),
          ),
          SizedBox(height: Height * 0.075,),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal.shade400
            ),
            onPressed: () async {
              setState(() {
                reload = true;
                Future.delayed(Duration(seconds: 2),(){
                  reload = false;
                  setState(() {});
                });
              });
              await _initializeRelays();  // Reload data
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 23),
              child: Icon(Icons.refresh, color: Colors.orangeAccent, size: 36),
            ),
          )

        ],
      );
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          collapse = !collapse;
          print(collapse);
        });
      },
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child:Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFFC9E8E6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.6),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.devices,
                          size: 30,
                          color: Colors.teal,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("IoT Device", style: TextStyle(color: Colors.teal.shade600, fontSize: 18, fontWeight: FontWeight.bold,),),
                            SizedBox(height: 6),
                            Text("Active", style: TextStyle(color: Colors.teal.shade400, fontSize: 15,),),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios, color: Colors.black, size: 24,),
                    ],
                  ),
                  collapse
                  ?
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Container(color: Colors.black.withOpacity(0.1), height: 2,),
                      ),
                      Column(
                        children: [
                          _buildRelaySwitch(1),
                          _buildRelaySwitch(2),
                          _buildRelaySwitch(3),
                          _buildRelaySwitch(4),
                          SizedBox(height: 20,),
                          ElevatedButton.icon(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => DeviceScreen()),
                            ),
                            icon: Icon(Icons.edit, color: Colors.teal,),        // The icon to display
                            label: Text('Edit', style: TextStyle(color: Colors.teal),),      // The text label
                          ),
                        ],
                      )
                    ],
                  )
                  :
                  SizedBox()
                ],
              ),
            )
      ),
    );
  }
}
