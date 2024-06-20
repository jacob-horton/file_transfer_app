import 'dart:io';

import 'package:file_transfer/services/webrtc.dart';
import 'package:file_transfer/widgets/attachments.dart';
import 'package:file_transfer/widgets/button.dart';
import 'package:file_transfer/widgets/people.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:heroicons/heroicons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RoomScreen extends StatefulWidget {
  const RoomScreen({super.key});

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  late WebRTCListener _webRTCListener;
  dynamic incomingSDPOffer;

  final TextEditingController _usernameController = TextEditingController();

  String roomCode = "very-funny-elephant";

  List<String> imagePaths = [];
  List<String> filePaths = [
    'example-file-1.png',
    'invoice.pdf',
    'important-document.txt',
    'presentation.pptx',
    'another-file.xlsx',
  ];
  List<String> people = [
    'Aaron',
    'Ellie',
    'Enzo',
    'George',
    'Evie',
    'Ross',
    'Monica'
  ];

  bool loadingPhotos = false;

  @override
  void initState() {
    super.initState();
    _setupWebRTCHandler();
    _loadUsername();
  }

  void _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    _usernameController.text = prefs.getString('username') ?? '';
  }

  _setupWebRTCHandler() async {
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
        toolbarHeight: 90,
        titleSpacing: 0,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12.0), // Hack to get alignment better
            Text(
              "Room code",
              // Hack to remove spacing between this and the title
              style:
                  Theme.of(context).textTheme.bodySmall!.copyWith(height: 0.01),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(roomCode, style: Theme.of(context).textTheme.titleMedium),
                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: IconButton(
                    icon: const HeroIcon(HeroIcons.clipboard),
                    style: IconButton.styleFrom(
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    iconSize: 20,
                    onPressed: () async {
                      await Clipboard.setData(ClipboardData(text: roomCode));
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 30.0, right: 30.0, bottom: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Attachments(
                  imagePaths: imagePaths,
                  filePaths: filePaths,
                  isLoadingMore: loadingPhotos,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Divider(color: Theme.of(context).colorScheme.secondary),
              ),
              Expanded(
                child: People(people: people, selected: const [1, 3, 4]),
              ),
              const SizedBox(height: 25.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // TODO: fixed width instead?
                  Expanded(
                    flex: 2,
                    child: CustomButton(
                      onPressed: () {},
                      heroIcon: HeroIcons.paperAirplane,
                      text: "Send",
                      type: CustomButtonType.cta,
                    ),
                  ),
                  Expanded(flex: 1, child: Container()),
                  CustomButton(
                    onPressed: () async {
                      setState(() {
                        loadingPhotos = true;
                      });

                      final picker = ImagePicker();
                      final images = await picker.pickMultiImage();
                      setState(() {
                        imagePaths.addAll(images.map((i) => i.path));
                        loadingPhotos = false;
                      });
                    },
                    heroIcon: HeroIcons.plusCircle,
                    type: CustomButtonType.main,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
