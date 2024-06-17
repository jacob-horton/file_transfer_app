import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

enum CustomButtonType {
  cta,
  main,
  secondary,
}

class CustomButton extends StatefulWidget {
  final void Function() onPressed;
  final HeroIcons heroIcon;
  final String? text;
  final CustomButtonType type;

  const CustomButton({
    super.key,
    required this.onPressed,
    required this.heroIcon,
    this.text,
    required this.type,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    var child = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        HeroIcon(widget.heroIcon),
        if (widget.text != null)
          Row(children: [
            const SizedBox(width: 5.0),
            Text(widget.text!),
            const SizedBox(width: 2.0), // Visual balance
          ]),
      ],
    );

    switch (widget.type) {
      case CustomButtonType.cta:
        return FilledButton(
          onPressed: widget.onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.tertiary,
          ),
          child: child,
        );
      case CustomButtonType.main:
        return FilledButton(
          onPressed: widget.onPressed,
          child: child,
        );
      case CustomButtonType.secondary:
        return OutlinedButton(
          onPressed: widget.onPressed,
          child: child,
        );
    }
  }
}
