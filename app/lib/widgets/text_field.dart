import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final String? hintText;
  final RegExp? allowedPattern;
  final Widget? icon;
  final TextEditingController? controller;

  final void Function(String)? onChanged;

  const CustomTextField({
    super.key,
    this.hintText,
    this.allowedPattern,
    this.icon,
    this.onChanged,
    this.controller,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  static const maxLength = 64;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 5.0, bottom: 2.0),
          child: Text(
            widget.hintText ?? '',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        TextField(
          controller: widget.controller,
          onChanged: widget.onChanged,
          style: Theme.of(context).textTheme.bodyMedium,
          inputFormatters: widget.allowedPattern != null
              ? [
                  FilteringTextInputFormatter.allow(widget.allowedPattern!),
                  LengthLimitingTextInputFormatter(maxLength),
                ]
              : [LengthLimitingTextInputFormatter(maxLength)],
          decoration: InputDecoration(
            suffixIcon: widget.icon,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 15.0,
            ),
          ),
        ),
      ],
    );
  }
}
