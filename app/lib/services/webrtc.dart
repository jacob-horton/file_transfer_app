import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'signalling_service.dart';

class WebRTCListener {
  RTCPeerConnection? _rtcPeerConnection;
  RTCDataChannel? _rtcDataChannel;

  List<RTCIceCandidate> rtcIceCandidates = [];
  List<String> listenerIds = [];

  dynamic _offer;

  Function(dynamic data) onIncomingRequest;

  WebRTCListener({required this.onIncomingRequest});

  _setupPeerConnection() async {
    _rtcPeerConnection = await createPeerConnection({
      'iceServers': [
        {
          'urls': [
            'stun:stun1.l.google.com:19302',
            'stun:stun2.l.google.com:19302'
          ]
        }
      ]
    });
  }

  dispose() async {
    for (var id in listenerIds) {
      SignallingService.instance.removeListener(id);
    }

    await _rtcPeerConnection!.close();
    _rtcDataChannel = null;
    _rtcPeerConnection = null;
    _offer = null;
  }

  reset() async {
    await dispose();
    await setupIncomingConnection();
  }

  setupIncomingConnection() async {
    await _setupPeerConnection();

    _rtcPeerConnection!.onDataChannel = (channel) {
      channel.onMessage = (data) async {
        // TODO: download file
        print(data.text);
        // TODO: return message

        await reset();
      };

      // For sending back
      _rtcDataChannel = channel;
    };

    listenerIds.add(SignallingService.instance.addListener("connectionRequest",
        (_, message) {
      _offer = message["data"]["offer"];
      onIncomingRequest(message["data"]);
    }));

    listenerIds.add(
      SignallingService.instance.addListener("iceCandidates", (_, data) async {
        for (var iceCandidate in data["data"]) {
          String candidate = iceCandidate["candidate"];
          String sdpMid = iceCandidate["id"];
          int sdpMLineIndex = iceCandidate["label"];

          // add iceCandidate
          await _rtcPeerConnection!.addCandidate(RTCIceCandidate(
            candidate,
            sdpMid,
            sdpMLineIndex,
          ));
        }

        SignallingService.instance.sendMessage("readyToReceive");
      }),
    );
  }

  acceptIncomingConnection() async {
    // TODO: check offer is set

    // set SDP offer as remoteDescription for peerConnection
    await _rtcPeerConnection!.setRemoteDescription(
      RTCSessionDescription(_offer["sdp"], _offer["type"]),
    );

    // create SDP answer
    RTCSessionDescription answer = await _rtcPeerConnection!.createAnswer();

    // set SDP answer as localDescription for peerConnection
    _rtcPeerConnection!.setLocalDescription(answer);

    // send SDP answer to remote peer over signalling
    SignallingService.instance.sendMessage(
      "connectionResponse",
      data: answer.toMap(),
    );
  }
}

class WebRTCInitiator {
  RTCPeerConnection? _rtcPeerConnection;
  RTCDataChannel? _rtcDataChannel;

  List<RTCIceCandidate> rtcIceCandidates = [];
  List<String> listenerIds = [];

  _setupPeerConnection() async {
    _rtcPeerConnection = await createPeerConnection({
      'iceServers': [
        {
          'urls': [
            'stun:stun1.l.google.com:19302',
            'stun:stun2.l.google.com:19302'
          ]
        }
      ]
    });
  }

  _setupOutgoingConnection() async {
    await _setupPeerConnection();

    // listen for local iceCandidate and add it to the list of IceCandidate
    _rtcPeerConnection!.onIceCandidate =
        (RTCIceCandidate candidate) => rtcIceCandidates.add(candidate);

    RTCDataChannelInit chanInit = RTCDataChannelInit();
    _rtcDataChannel =
        await _rtcPeerConnection!.createDataChannel('chat', chanInit);

    _rtcDataChannel!.onMessage = (data) {
      // TODO: handle response after data received
      print(data.text);
    };

    listenerIds.add(
      SignallingService.instance.addListener("connectionResponse",
          (_, event) async {
        // set SDP answer as remoteDescription for peerConnection
        await _rtcPeerConnection!.setRemoteDescription(
          RTCSessionDescription(
            event["data"]["sdp"],
            event["data"]["type"],
          ),
        );

        SignallingService.instance.sendMessage(
          "iceCandidates",
          data: rtcIceCandidates
              .map((c) => {
                    "id": c.sdpMid,
                    "label": c.sdpMLineIndex,
                    "candidate": c.candidate,
                  })
              .toList(),
        );
      }),
    );

    listenerIds.add(
      SignallingService.instance.addListener("readyToReceive",
          (_, event) async {
        // TODO: on connected callback
        await _rtcDataChannel!.send(RTCDataChannelMessage("yooo, connected"));

        for (var id in listenerIds) {
          SignallingService.instance.removeListener(id);
        }

        await _rtcPeerConnection!.close();
      }),
    );
  }

  // Outgoing
  makeConnectionRequest(int numFiles, int numImages) async {
    await _setupOutgoingConnection();

    // create SDP Offer
    RTCSessionDescription offer = await _rtcPeerConnection!.createOffer();

    // set SDP offer as localDescription for peerConnection
    await _rtcPeerConnection!.setLocalDescription(offer);

    // request to send data
    // TODO: pass through who to send to
    SignallingService.instance.sendMessage('connectionRequest', data: {
      "offer": offer.toMap(),
      "contents": {
        "numFiles": numFiles,
        "numImages": numImages,
      }
    });
  }
}
