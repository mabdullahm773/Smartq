import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tappo/api/relay_model.dart';

String ipAndPort = '192.168.100.11:5099';
String get baseUrl => 'http://$ipAndPort/relay';


class RelayApiService {

  static Future<List<RelayChannel>> fetchRelays() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => RelayChannel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load relays');
    }
  }

  static Future<void> updateRelay(RelayChannel relay) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${relay.id}'), // <-- Add ID to URL for PUT
      headers: {'Content-Type': 'application/json'},
      body: json.encode(relay.toJson()),
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to update relay');
    }
  }

}
