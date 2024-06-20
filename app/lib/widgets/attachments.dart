import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

class Attachments extends StatefulWidget {
  final List<String> imagePaths;
  final List<String> filePaths;
  final bool isLoadingMore;

  const Attachments({
    super.key,
    required this.imagePaths,
    required this.filePaths,
    required this.isLoadingMore,
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
        Text("Attachments", style: Theme.of(context).textTheme.titleSmall),
        SizedBox(
          height: 80,
          // TODO: not working
          child: CupertinoScrollbar(
            child: ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, i) {
                if (widget.isLoadingMore && i == widget.imagePaths.length) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.only(left: 20.0),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  );
                }

                return Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: imagePreview(context, widget.imagePaths[i]),
                  ),
                );
              },
              separatorBuilder: (context, _) => const SizedBox(width: 10),
              itemCount:
                  widget.imagePaths.length + (widget.isLoadingMore ? 1 : 0),
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
                        size: 14,
                      ),
                      style: IconButton.styleFrom(
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
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

  Widget imagePreview(BuildContext context, String imagePath) {
    const size = 75.0;

    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: ExtendedImage.file(
        File(imagePath),
        cacheWidth: 128,
        fit: BoxFit.cover,
        enableLoadState: true,
        loadStateChanged: (ExtendedImageState state) {
          switch (state.extendedImageLoadState) {
            case LoadState.loading:
              return SizedBox(
                width: size,
                height: size,
                child: Container(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              );
            case LoadState.completed:
              return ExtendedRawImage(
                image: state.extendedImageInfo?.image,
                fit: BoxFit.cover,
                width: size,
                height: size,
              );
            case LoadState.failed:
              return GestureDetector(
                child: SizedBox(
                  width: size,
                  height: size,
                  child: Container(
                    color: Theme.of(context).colorScheme.secondary,
                    child: Center(
                      child: HeroIcon(
                        HeroIcons.exclamationCircle,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  state.reLoadImage();
                },
              );
          }
        },
        width: size,
        height: size,
      ),
    );
  }
}
