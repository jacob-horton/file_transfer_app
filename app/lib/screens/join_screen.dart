import 'dart:ui';

import 'package:file_transfer/services/webrtc.dart';
import 'package:file_transfer/widgets/button.dart';
import 'package:file_transfer/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
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
          child: Stack(
            children: [
              const MyFloatingActionButton(),
              const CustomTextField(hintText: "Username"),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const CustomTextField(hintText: "Room code"),
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
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                        onPressed: () {},
                      ),
                    ),
                  ],
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
      ),
    );
  }
}

class MyFloatingActionButton extends StatelessWidget {
  const MyFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: disable when sending/receiving
    const canClose = true;

    const title = "Confirm send";
    const images = 24;
    const files = 6;
    const people = 2;

    return Positioned(
      bottom: 60.0,
      child: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isDismissible: canClose,
            enableDrag: canClose,
            backgroundColor: Colors.transparent,
            builder: (context) => PopScope(
              canPop: canClose,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  // alignment: Alignment.center,
                  padding: const EdgeInsets.all(15.0),
                  margin: const EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(title),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          children: [
                            const TextSpan(text: "\u2022 "),
                            TextSpan(
                              text: images.toString(),
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context).colorScheme.tertiary,
                              ),
                            ),
                            const TextSpan(text: " images"),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          children: [
                            const TextSpan(text: "\u2022 "),
                            TextSpan(
                              text: files.toString(),
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context).colorScheme.tertiary,
                              ),
                            ),
                            const TextSpan(text: " files"),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          children: [
                            const TextSpan(text: "To "),
                            TextSpan(
                              text: people.toString(),
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context).colorScheme.tertiary,
                              ),
                            ),
                            const TextSpan(text: " people"),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: CustomButton(
                              text: "Cancel",
                              heroIcon: HeroIcons.xCircle,
                              onPressed: () => Navigator.of(context).pop(),
                              type: CustomButtonType.secondary,
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          Expanded(
                            child: CustomButton(
                              text: "Send",
                              heroIcon: HeroIcons.paperAirplane,
                              onPressed: () => {},
                              type: CustomButtonType.cta,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
