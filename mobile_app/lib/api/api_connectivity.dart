import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:tappo/api/relay_channel.dart';

Future<List<RelayChannel>> fetchRelayChannels() async {
  final response = await http.get(Uri.parse('http://192.168.100.11:5099/relay'));
  if (response.statusCode == 200) {
    final List<dynamic> relayList = jsonDecode(response.body);
    return relayList
        .map((json) => RelayChannel.fromJson(json))
        .where((relay) => [1, 2, 3, 4].contains(relay.id))
        .toList();
  } else {
    throw Exception('Failed to load relay channels');
  }
}
