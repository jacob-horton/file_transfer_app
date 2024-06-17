import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

class Attachments extends StatefulWidget {
  final List<String> imagePaths;
  final List<String> filePaths;

  const Attachments({
    super.key,
    required this.imagePaths,
    required this.filePaths,
  });

  @override
  State<Attachments> createState() => _AttachmentsState();
}

class _AttachmentsState extends State<Attachments> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Attachments"),
        SizedBox(
          height: 80,
          // TODO: not working
          child: CupertinoScrollbar(
            child: ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, i) => Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.file(
                    File(widget.imagePaths[i]),
                    fit: BoxFit.cover,
                    width: 75,
                    height: 75,
                  ),
                ),
              ),
              separatorBuilder: (context, _) => const SizedBox(width: 10),
              itemCount: widget.imagePaths.length,
              scrollDirection: Axis.horizontal,
            ),
          ),
        ),
        const SizedBox(height: 20.0),
        Expanded(
          child: CupertinoScrollbar(
            child: ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, i) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Row(
                  children: [
                    const HeroIcon(HeroIcons.documentText),
                    const SizedBox(width: 10.0),
                    Text(widget.filePaths[i]),
                    Expanded(child: Container()),
                    IconButton(
                      icon: const HeroIcon(
                        HeroIcons.xMark,
                        style: HeroIconStyle.mini,
                      ),
                      style: IconButton.styleFrom(
                        iconSize: 14,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      iconSize: 20,
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              separatorBuilder: (context, _) => const SizedBox(height: 5),
              itemCount: widget.filePaths.length,
            ),
          ),
        ),
      ],
    );
  }
}
