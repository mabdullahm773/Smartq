import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Relay> fetchRelayById(int id) async {
  final url = Uri.parse('http://192.168.0.101:5099/relay/$id'); // Replace with real IP or domain if needed
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    return Relay.fromJson(jsonData);
  } else {
    throw Exception('Failed to fetch relay data');
  }
}


class Relay {
  final int id;
  final String deviceName;
  final bool relayStatus;

  Relay({
    required this.id,
    required this.deviceName,
    required this.relayStatus,
  });

  factory Relay.fromJson(Map<String, dynamic> json) {
    return Relay(
      id: json['id'],
      deviceName: json['deviceName'],
      relayStatus: json['relayStatus'],
    );
  }
}
