import 'dart:convert';

import 'package:uuid/uuid.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class SignallingService {
  WebSocketChannel? _socket;
  Uuid uuid = const Uuid();
  bool isProcessingMessage = false;

  SignallingService._();
  static final instance = SignallingService._();

  Map<String, Map<String, Function(String, dynamic)>> listeners = {};
  List<String> listenersToRemove = [];

  String? peopleUpdatedListenerId;

  init({required String websocketUrl, required String username}) {
    _socket = WebSocketChannel.connect(Uri.parse(websocketUrl));

    SignallingService.instance._socket!.stream.listen((message) {
      isProcessingMessage = true;
      message = json.decode(message);
      listeners[message["event"]]?.forEach((k, l) {
        l(k, message);
      });

      isProcessingMessage = false;
      if (listenersToRemove.isNotEmpty) {
        for (var ls in listeners.values) {
          ls.removeWhere((id, _) => listenersToRemove.contains(id));
        }
      }
    });

    SignallingService.instance.sendMessage("init", data: username);
  }

  addListener(String event, Function(String, dynamic) listener) {
    var id = uuid.v1();
    listeners.putIfAbsent(event, () {
      return {};
    })[id] = listener;

    return id;
  }

  removeListener(String id) {
    // Schedule remove for after message is processed
    if (isProcessingMessage) {
      listenersToRemove.add(id);
      return;
    }

    for (var ls in listeners.values) {
      if (ls.remove(id) != null) {
        return;
      }
    }
  }

  sendMessage(String event, {dynamic data}) {
    _socket!.sink.add(json.encode({
      "event": event,
      "data": data,
    }));
  }
}
