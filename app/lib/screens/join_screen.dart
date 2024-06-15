import 'package:file_transfer/services/webrtc.dart';
import 'package:file_transfer/widgets/bottom_modal.dart';
import 'package:file_transfer/widgets/button.dart';
import 'package:file_transfer/widgets/confirm_send.dart';
import 'package:file_transfer/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

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
        title: const Padding(
          padding: EdgeInsets.only(top: 30.0),
          child: Text("Welcome!"),
        ),
        titleSpacing: 30.0,
        primary: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomTextField(
                hintText: "Username",
                allowedPattern: RegExp("[a-zA-Z0-9-_]"),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomTextField(
                      hintText: "Room code",
                      // Pattern matches for word1-word2-word3-...
                      allowedPattern: RegExp(r"[a-zA-Z](-[a-zA-Z]+)*-?"),
                    ),
                    const SizedBox(height: 10.0),
                    CustomButton(
                      type: CustomButtonType.main,
                      text: "Join",
                      heroIcon: HeroIcons.arrowRightCircle,
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      type: CustomButtonType.secondary,
                      text: "Help",
                      heroIcon: HeroIcons.questionMarkCircle,
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    flex: 2,
                    child: CustomButton(
                      type: CustomButtonType.cta,
                      text: "Create",
                      heroIcon: HeroIcons.plusCircle,
                      onPressed: () {
                        showBottomModal(
                          context: context,
                          title: "Confirm send",
                          // TODO: disable when sending/receiving
                          canClose: true,
                          child: const ConfirmSend(
                            numPeople: 2,
                            numImages: 24,
                            numFiles: 6,
                          ),
                        );
                      },
                    ),
                  ),
                ],
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
      ),
    );
  }
}
