import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

void showBottomModal({
  required BuildContext context,
  required Widget child,
  required bool canClose,
  required String title,
}) {
  showModalBottomSheet(
    context: context,
    isDismissible: canClose,
    enableDrag: canClose,
    backgroundColor: Colors.transparent,
    builder: (context) => BottomModal(
      canClose: canClose,
      title: title,
      child: child,
    ),
  );
}

class BottomModal extends StatefulWidget {
  final String title;
  final bool canClose;
  final Widget child;

  const BottomModal({
    super.key,
    required this.title,
    required this.canClose,
    required this.child,
  });

  @override
  State<BottomModal> createState() => _BottomModalState();
}

class _BottomModalState extends State<BottomModal> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: widget.canClose,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          padding: const EdgeInsets.all(20.0),
          margin: const EdgeInsets.all(15.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    if (widget.canClose)
                      IconButton(
                        padding: const EdgeInsets.symmetric(
                          vertical: 2.0,
                          horizontal: 3.0,
                        ),
                        style: IconButton.styleFrom(
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        icon: const HeroIcon(
                          HeroIcons.xMark,
                          size: 18.0,
                          style: HeroIconStyle.micro,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                  ],
                ),
              ),
              widget.child,
            ],
          ),
        ),
      ),
    );
  }
}
