import 'api_connectivity.dart';
import 'relay_model.dart';

class RelayData {
  List<RelayChannel> relays = [];

  Future<void> loadRelays() async {
    relays = await  RelayApiService.fetchRelays();
  }

  RelayChannel getRelayById(int id) {
    return relays.firstWhere((r) => r.id == id);
  }

  Future<void> toggleRelay(int id) async {
    RelayChannel relay = getRelayById(id);
    relay.relayStatus = !relay.relayStatus;
    await RelayApiService.updateRelay(relay);
  }
}
