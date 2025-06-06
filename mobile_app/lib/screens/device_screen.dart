import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tappo/services/screen_size_service.dart';
import 'package:tappo/widgets/custom_pop_message.dart';
import 'package:tappo/widgets/loading_widget.dart';
import '../api/api_connectivity.dart';
import '../api/relay_model.dart';
import '../widgets/appbar_widget.dart';

class DeviceScreen extends StatefulWidget {
  @override
  _DeviceScreenState createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<DeviceScreen> {
  List<RelayChannel> _relays = [];
  bool predataload = true;
  @override
  void initState() {
    super.initState();
    _loadRelays();
  }

  Future<void> _loadRelays() async {
    Future.delayed(Duration(milliseconds: 500) ,(){
      predataload = false;
      setState(() {});
    });
    final relays = await RelayApiService.fetchRelays();
    setState(() {
      _relays = relays;
    });
  }

  Future<void> _updateDeviceName(int index, String newName) async {
    final relay = _relays[index];
    final updatedRelay = RelayChannel(
      id: relay.id,
      deviceName: newName,
      relayStatus: relay.relayStatus,
    );

    await RelayApiService.updateRelay(updatedRelay);
    await _loadRelays();
  }

  void _showEditDialog(int index) {
    final controller = TextEditingController(text: _relays[index].deviceName);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text('Rename Device', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: 'Device Name',
            labelStyle: TextStyle(color: Colors.teal, fontSize: 16, fontWeight: FontWeight.w400),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.red),),
          ),
          ElevatedButton(
            onPressed: () {

              _updateDeviceName(index, controller.text.trim());
              Navigator.pop(context);
              showDialog(
                  context: context,
                  builder: (BuildContext) => SuccessMessage(title: "Device Name Changed",onOkPressed: ()=> Navigator.pop(context),)
              );
            },
            child: Text('Save', style: TextStyle(color: Colors.green),),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }

  void _showLoading(){
    showLoadingDialog(context);
  }

  Widget buildRelayCard(int index) {
    final relay = _relays[index];
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Card(
        color: Color(0xFFC9E8E6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        margin: EdgeInsets.symmetric(vertical: 8),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          title: Text(
            relay.deviceName ?? 'Unnamed Device',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600, color: Colors.teal.shade800),
          ),
          subtitle: Text('Relay ID: ${relay.id}', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: Colors.teal.shade600),),
          trailing: Icon(Icons.edit, color: Colors.teal),
          onTap: () => _showEditDialog(index),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: predataload
      ? Column(
        children: [
          CustomAppBar(Title: "Edit Device Names", BackButton: true, ProfileIcon: false,),
          SizedBox(height: Height * 0.32,),
          SpinKitCircle(color: Colors.grey, size: 65,),
          SizedBox(height: Height * 0.03,),
          Text("Loading Please Wait ....", style: TextStyle(color: Colors.grey, fontSize: 16),)
        ],
      )
      : SingleChildScrollView(
          child: Column(
            children: [
              CustomAppBar(Title: "Edit Device Names", BackButton: true, ProfileIcon: false,),
              buildRelayCard(0),
              buildRelayCard(1),
              buildRelayCard(2),
              buildRelayCard(3),
            ],
          ),
        )
    );
  }
}
