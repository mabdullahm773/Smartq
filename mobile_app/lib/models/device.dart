import 'package:cloud_firestore/cloud_firestore.dart';

class Device {
  final String deviceName;
  final String macAddress;
  final String status;
  final String activationTime;
  final String lastActive;
  final String otherDetails;

  Device({
    required this.deviceName,
    required this.macAddress,
    required this.status,
    required this.activationTime,
    required this.lastActive,
    required this.otherDetails,
  });

  // Convert Firestore document to Device object
  factory Device.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>; // Extract the data as a map from the document
    return Device(
      deviceName: data['deviceName'] ?? '',  // Mapping deviceName
      macAddress: doc.id,  // Using doc.id as the MAC address
      status: data['status'] ?? '',  // Mapping status
      activationTime: data['activationTime'] ?? '',  // Mapping activationTime
      lastActive: data['lastActive'] ?? '',  // Mapping lastActive
      otherDetails: data['otherDetails'] ?? '',  // Mapping otherDetails
    );
  }
}
