import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final String? hintText;
  final RegExp? allowedPattern;

  const CustomTextField({super.key, this.hintText, this.allowedPattern});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
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
          style: Theme.of(context).textTheme.bodyMedium,
          inputFormatters: widget.allowedPattern != null
              ? [FilteringTextInputFormatter.allow(widget.allowedPattern!)]
              : [],
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(
              horizontal: 15.0,
            ),
          ),
        ),
      ],
    );
  }
}
