import 'dart:convert';

import 'package:file_transfer/screens/room_screen.dart';
import 'package:file_transfer/services/signalling_service.dart';
import 'package:file_transfer/widgets/button.dart';
import 'package:file_transfer/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JoinScreen extends StatefulWidget {
  const JoinScreen({super.key});

  @override
  State<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  final String websocketUrl = "ws://192.168.0.63:5000";

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _roomCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  void _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    _usernameController.text = prefs.getString('username') ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        toolbarHeight: 90,
        title: const Text("Welcome!"),
        titleSpacing: 30.0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 30.0, right: 30.0, bottom: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomTextField(
                hintText: "User123",
                labelText: "Username",
                allowedPattern: RegExp("[a-zA-Z0-9-_]"),
                icon: const HeroIcon(HeroIcons.pencil, size: 18.0),
                controller: _usernameController,
                onChanged: (value) async {
                  // TODO: debounce
                  final prefs = await SharedPreferences.getInstance();
                  prefs.setString('username', value);
                },
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomTextField(
                      hintText: "very-funny-elephant",
                      labelText: "Room code",
                      controller: _roomCodeController,
                      // Pattern matches for word1-word2-word3-...
                      allowedPattern: RegExp(r"[a-zA-Z](-[a-zA-Z]+)*-?"),
                    ),
                    const SizedBox(height: 10.0),
                    CustomButton(
                      type: CustomButtonType.main,
                      text: "Join",
                      heroIcon: HeroIcons.arrowRightCircle,
                      onPressed: () {
                        String username = _usernameController.text;
                        String roomCode = _roomCodeController.text;
                        _roomCodeController.clear();

                        SignallingService.instance.addListener("roomJoined",
                            (id, event) {
                          dynamic data = json.decode(event["data"]);
                          String roomCode = data["roomName"];
                          List<String> people =
                              List<String>.from(data["people"] as List);
                          SignallingService.instance.removeListener(id);

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => RoomScreen(
                                roomCode: roomCode,
                                initialPeople: people,
                                username: username,
                              ),
                            ),
                          );
                        });

                        SignallingService.instance.init(
                          websocketUrl: "$websocketUrl/join-room/$roomCode",
                          username: username,
                        );
                      },
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
                        SignallingService.instance.addListener("roomJoined",
                            (id, event) {
                          dynamic data = json.decode(event["data"]);
                          String roomCode = data["roomName"];
                          List<String> people =
                              List<String>.from(data["people"] as List);
                          SignallingService.instance.removeListener(id);

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => RoomScreen(
                                roomCode: roomCode,
                                initialPeople: people,
                                username: _usernameController.text,
                              ),
                            ),
                          );
                        });

                        SignallingService.instance.init(
                          websocketUrl: "$websocketUrl/create-room",
                          username: _usernameController.text,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
