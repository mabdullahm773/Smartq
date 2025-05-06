import 'package:flutter/material.dart';

class DeviceCard extends StatelessWidget {
  final String deviceName;
  final String status;
  final IconData deviceIcon;
  final VoidCallback onTap;

  const DeviceCard({
    super.key,
    required this.deviceName,
    required this.status,
    required this.deviceIcon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFFC500), Color(0xFFFF9A4D),],
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
                  color: Colors.red.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  deviceIcon,
                  size: 30,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(deviceName, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold,),),
                    SizedBox(height: 6),
                    Text(status, style: TextStyle(color: Colors.white70, fontSize: 14,),),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 20,)
            ],
          ),
        ),
      ),
    );
  }
}
