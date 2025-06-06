class RelayChannel {
  final int id;
  final String? deviceName;
  bool relayStatus;

  RelayChannel({
    required this.id,
    this.deviceName,
    required this.relayStatus,
  });

  factory RelayChannel.fromJson(Map<String, dynamic> json) {
    return RelayChannel(
      id: json['id'],
      deviceName: json['deviceName'],
      relayStatus: json['relayStatus'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'deviceName': deviceName,
    'relayStatus': relayStatus,
  };
}
