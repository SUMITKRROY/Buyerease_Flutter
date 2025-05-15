import 'package:flutter/material.dart';

class CircularImageView extends StatelessWidget {
    final ImageProvider imageProvider;
    final double borderWidth;
    final Color borderColor;
    final bool hasBorder;
    final bool hasShadow;
    final double size;

    const CircularImageView({
        Key? key,
        required this.imageProvider,
        this.borderWidth = 4.0,
        this.borderColor = Colors.white,
        this.hasBorder = true,
        this.hasShadow = false,
        this.size = 0.0, // 0 means use image's intrinsic size or parent constraints
    }) : super(key: key);

    @override
    Widget build(BuildContext context) {
        final density = MediaQuery.of(context).devicePixelRatio;
        final adjustedBorderWidth = borderWidth * density / 2;

        Widget image = ClipOval(
            child: Image(
                image: imageProvider,
                fit: BoxFit.cover,
                width: size > 0 ? size : null,
                height: size > 0 ? size : null,
            ),
        );

        if (hasBorder) {
            image = DecoratedBox(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: borderColor,
                        width: adjustedBorderWidth,
                    ),
                ),
                child: Padding(
                    padding: EdgeInsets.all(adjustedBorderWidth),
                    child: image,
                ),
            );
        }

        if (hasShadow) {
            image = DecoratedBox(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 4.0,
                            offset: const Offset(0, 2),
                        ),
                    ],
                ),
                child: image,
            );
        }

        return image;
    }
}