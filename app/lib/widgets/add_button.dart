// Based on https://medium.com/@gshubham030/custom-dropdown-menu-in-flutter-7d8d1e026c6b
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

class AddButton extends StatefulWidget {
  final void Function() onAddFile;
  final void Function() onAddImage;

  const AddButton({
    super.key,
    required this.onAddFile,
    required this.onAddImage,
  });

  @override
  State<AddButton> createState() => _AddButtonState();
}

class _AddButtonState extends State<AddButton> {
  final btnKey = GlobalKey();

  OverlayEntry? overlayEntry;
  Offset? btnPos;
  Size? btnSize;
  bool showMenu = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (showMenu) {
          _closeMenu();
        } else {
          _openMenu();
        }
      },
      child: Container(
        key: btnKey,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(15.0),
        ),
        // TODO: size better to match buttons
        child: SizedBox(
          width: 55,
          height: 55,
          child: HeroIcon(
            HeroIcons.plusCircle,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }

  _findButton() {
    RenderBox renderBox =
        btnKey.currentContext!.findRenderObject() as RenderBox;
    btnSize = renderBox.size;
    btnPos = renderBox.localToGlobal(Offset.zero);
  }

  OverlayEntry _overlayEntryBuilder() {
    return OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            // Handle clicking off the menu
            Positioned.fill(
              child: GestureDetector(
                onTap: _closeMenu,
                behavior: HitTestBehavior.opaque,
              ),
            ),
            Positioned(
              bottom: MediaQuery.of(context).size.height - btnPos!.dy + 15,
              right: MediaQuery.of(context).size.width -
                  btnPos!.dx -
                  btnSize!.width,
              child: Material(
                color: Colors.transparent,
                child: Menu(
                  onAddFile: () {
                    widget.onAddFile();
                    _closeMenu();
                  },
                  onAddImage: () {
                    widget.onAddImage();
                    _closeMenu();
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _openMenu() {
    _findButton();
    overlayEntry = _overlayEntryBuilder();
    Overlay.of(context).insert(overlayEntry!);
    showMenu = !showMenu;
  }

  void _closeMenu() {
    overlayEntry!.remove();
    showMenu = !showMenu;
  }
}

class Menu extends StatelessWidget {
  final arrowSize = 25.0;

  final void Function() onAddFile;
  final void Function() onAddImage;

  const Menu({
    super.key,
    required this.onAddFile,
    required this.onAddImage,
  });

  @override
  Widget build(BuildContext context) {
    // Rotated 45 degrees, so corners overflow
    final diagonalLength = arrowSize * sqrt2;
    final arrowOverflowAmt = (diagonalLength - arrowSize) / 2;

    return Stack(
      alignment: Alignment.bottomRight,
      clipBehavior: Clip.none,
      children: [
        Positioned(
          right: arrowOverflowAmt + 10,
          bottom: -(diagonalLength / 2 - 12),
          child: Transform.rotate(
            angle: pi / 4,
            child: Container(
              width: arrowSize,
              height: arrowSize,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(15),
            // border: Border.all(
            //     color: Theme.of(context).colorScheme.primary.withAlpha(20)),
            // boxShadow: [
            //   BoxShadow(
            //     color: Theme.of(context).colorScheme.primary.withAlpha(20),
            //     spreadRadius: 0,
            //     blurRadius: 10,
            //     offset: Offset(0, 3),
            //   ),
            // ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 30, 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    onAddImage();
                  },
                  child: const Row(
                    children: [
                      HeroIcon(HeroIcons.photo),
                      SizedBox(width: 8),
                      Text("Image"),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    onAddFile();
                  },
                  child: const Row(
                    children: [
                      HeroIcon(HeroIcons.documentText),
                      SizedBox(width: 8),
                      Text("File"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
