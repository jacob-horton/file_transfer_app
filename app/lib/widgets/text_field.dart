import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String? hintText;
  const CustomTextField({super.key, this.hintText});

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
        const TextField(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
              horizontal: 15.0,
            ),
          ),
        ),
      ],
    );
  }
}
