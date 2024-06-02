import 'package:file_transfer/services/webrtc.dart';
import 'package:flutter/material.dart';

class RoomScreen extends StatefulWidget {
  const RoomScreen({super.key});

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  late WebRTCListener _webRTCListener;
  dynamic incomingSDPOffer;

  @override
  void initState() {
    super.initState();
    setupWebRTCHandler();
  }

  setupWebRTCHandler() async {
    _webRTCListener = WebRTCListener(
      onIncomingRequest: (offer) => setState(() => incomingSDPOffer = offer),
    );

    await _webRTCListener.setupIncomingConnection();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("P2P File Share App"),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      side: const BorderSide(color: Colors.white30),
                    ),
                    child: const Text(
                      "Send",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () async {
                      final webRTCInitiator = WebRTCInitiator();
                      await webRTCInitiator.makeConnectionRequest();
                    },
                  ),
                ),
              ),
            ),
            if (incomingSDPOffer != null)
              Positioned(
                child: ListTile(
                  title: const Text("Incoming files from TODO"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close),
                        color: Colors.redAccent,
                        onPressed: () {
                          setState(() => incomingSDPOffer = null);
                          // TODO: send rejected message
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.check),
                        color: Colors.greenAccent,
                        onPressed: () async {
                          await _webRTCListener.acceptIncomingConnection();
                          setState(() => incomingSDPOffer = null);
                        },
                      )
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
