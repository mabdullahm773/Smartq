import 'package:flutter/material.dart';

class DeviceCard extends StatefulWidget {
  final String deviceName;
  final String status;
  final IconData deviceIcon;

  const DeviceCard({
    super.key,
    required this.deviceName,
    required this.status,
    required this.deviceIcon,
  });

  @override
  State<DeviceCard> createState() => _DeviceCardState();
}

class _DeviceCardState extends State<DeviceCard> {
  late bool collapse;
  @override
  void initState() {
    collapse = false;
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
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
        child: collapse
          ? Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.grey.shade300, Colors.grey.shade400,],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  widget.deviceIcon,
                  size: 30,
                  color: Colors.deepPurpleAccent,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.deviceName, style: TextStyle(color: Colors.purpleAccent, fontSize: 18, fontWeight: FontWeight.bold,),),
                    SizedBox(height: 6),
                    Text(widget.status, style: TextStyle(color: Colors.purpleAccent, fontSize: 14,),),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.deepPurpleAccent, size: 24,),
            ],
          ),
        )
          : Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.grey.shade300, Colors.grey.shade400,],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          widget.deviceIcon,
                          size: 30,
                          color: Colors.deepPurpleAccent,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.deviceName, style: TextStyle(color: Colors.purpleAccent, fontSize: 18, fontWeight: FontWeight.bold,),),
                            SizedBox(height: 6),
                            Text(widget.status, style: TextStyle(color: Colors.purpleAccent, fontSize: 14,),),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios, color: Colors.deepPurpleAccent, size: 24,),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Container(color: Colors.black.withOpacity(0.1), height: 2,),
                  ),
                  SizedBox(height: 100,)
                ],
              ),
            ),
      ),
    );
  }
}
