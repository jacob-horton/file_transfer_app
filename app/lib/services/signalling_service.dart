import 'dart:convert';

import 'package:uuid/uuid.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class SignallingService {
  WebSocketChannel? socket;
  Uuid uuid = const Uuid();

  SignallingService._();
  static final instance = SignallingService._();

  Map<String, Map<String, Function(dynamic)>> listeners = {};

  init({required String websocketUrl}) {
    socket = WebSocketChannel.connect(Uri.parse(websocketUrl));

    SignallingService.instance.socket!.stream.listen((message) {
      message = json.decode(message);
      listeners[message["type"]]?.forEach((k, l) {
        l(message);
      });
    });
  }

  addListener(String event, Function(dynamic) listener) {
    var id = uuid.v1();
    listeners.putIfAbsent(event, () {
      return {};
    })[id] = listener;

    return id;
  }

  removeListener(String id) {
    for (var ls in listeners.values) {
      if (ls.containsKey(id)) {
        ls.remove(id);
        return;
      }
    }
  }

  // TODO: sending message - make socket private
}
