import 'package:file_transfer/widgets/confirm_modal.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

class ConfirmReceive extends StatefulWidget {
  final int numFiles;
  final int numImages;

  final void Function() onSend;

  const ConfirmReceive({
    super.key,
    required this.numFiles,
    required this.numImages,
    required this.onSend,
  });

  @override
  State<ConfirmReceive> createState() => _ConfirmReceiveState();
}

class _ConfirmReceiveState extends State<ConfirmReceive> {
  @override
  Widget build(BuildContext context) {
    return ConfirmModal(
      confirmText: "Accept",
      confirmIcon: HeroIcons.arrowDownTray,
      onConfirm: () {
        Navigator.of(context).pop();
        widget.onSend();
      },
      onCancel: () => Navigator.of(context).pop(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("You are about to receive"),
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
          // TODO: total size
          // const SizedBox(height: 10.0),
          // RichText(
          //   text: TextSpan(
          //     style: Theme.of(context).textTheme.bodyMedium!.copyWith(
          //           color: Theme.of(context).colorScheme.onSurface,
          //         ),
          //     children: [
          //       const TextSpan(text: "To "),
          //       TextSpan(
          //         text: widget.numPeople.toString(),
          //         style: Theme.of(context).textTheme.bodyLarge,
          //       ),
          //       TextSpan(text: widget.numPeople == 1 ? " person" : " people"),
          //     ],
          //   ),
          // ),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }
}
