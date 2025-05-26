class RelayChannel {
  final int id;
  final String? deviceName;
  final bool relayStatus;

  RelayChannel({required this.id, this.deviceName, required this.relayStatus});

  factory RelayChannel.fromJson(Map<String, dynamic> json) {
    return RelayChannel(
      id: json['id'],
      deviceName: json['deviceName'],
      relayStatus: json['relayStatus'],
    );
  }
}
