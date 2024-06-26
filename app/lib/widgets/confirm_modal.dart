import 'package:file_transfer/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

class ConfirmModal extends StatefulWidget {
  final String confirmText;
  final String cancelText;

  final HeroIcons confirmIcon;
  final HeroIcons cancelIcon;

  final void Function() onConfirm;
  final void Function() onCancel;

  final Widget child;

  const ConfirmModal({
    super.key,
    required this.child,
    required this.onCancel,
    required this.onConfirm,
    this.confirmText = "Confirm",
    this.cancelText = "Cancel",
    this.confirmIcon = HeroIcons.checkCircle,
    this.cancelIcon = HeroIcons.xCircle,
  });

  @override
  State<ConfirmModal> createState() => _ConfirmModalState();
}

class _ConfirmModalState extends State<ConfirmModal> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.child,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: CustomButton(
                text: widget.cancelText,
                heroIcon: widget.cancelIcon,
                onPressed: widget.onCancel,
                type: CustomButtonType.secondary,
              ),
            ),
            const SizedBox(width: 10.0),
            Expanded(
              child: CustomButton(
                text: widget.confirmText,
                heroIcon: widget.confirmIcon,
                onPressed: widget.onConfirm,
                type: CustomButtonType.cta,
              ),
            ),
          ],
        )
      ],
    );
  }
}
