import 'package:file_transfer/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

class ConfirmSend extends StatefulWidget {
  final int numPeople;
  final int numFiles;
  final int numImages;

  final void Function() onSend;

  const ConfirmSend({
    super.key,
    required this.numPeople,
    required this.numFiles,
    required this.numImages,
    required this.onSend,
  });

  @override
  State<ConfirmSend> createState() => _ConfirmSendState();
}

class _ConfirmSendState extends State<ConfirmSend> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("You are about to send"),
        const SizedBox(height: 3.0),
        RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
            children: [
              const TextSpan(text: "\u2022 "),
              TextSpan(
                text: widget.numImages.toString(),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              TextSpan(text: widget.numImages == 1 ? " image" : " images"),
            ],
          ),
        ),
        RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
            children: [
              const TextSpan(text: "\u2022 "),
              TextSpan(
                text: widget.numFiles.toString(),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              TextSpan(text: widget.numFiles == 1 ? " file" : " files"),
            ],
          ),
        ),
        const SizedBox(height: 10.0),
        RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
            children: [
              const TextSpan(text: "To "),
              TextSpan(
                text: widget.numPeople.toString(),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              TextSpan(text: widget.numPeople == 1 ? " person" : " people"),
            ],
          ),
        ),
        const SizedBox(height: 20.0),
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
                onPressed: () {
                  Navigator.of(context).pop();
                  widget.onSend();
                },
                type: CustomButtonType.cta,
              ),
            ),
          ],
        )
      ],
    );
  }
}
