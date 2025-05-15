import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight fontWeight;
  final List<Color>? gradientColors;
  final TextAlign textAlign;
  final double letterSpacing;
  final TextType? textType;
  final bool useGradient;

  const CustomText({
    super.key,
    required this.text,
    this.fontSize,
    this.textType,
    this.fontWeight = FontWeight.bold,
    this.gradientColors,
    this.textAlign = TextAlign.center,
    this.letterSpacing = 1.2,
    this.useGradient = true,
  });

  double _getFontSize() {
    if (fontSize != null) return fontSize!;
    
    switch (textType) {
      case TextType.heading:
        return 32.0;
      case TextType.subHeading:
        return 24.0;
      case TextType.title:
        return 20.0;
      case TextType.body:
        return 16.0;
      case TextType.caption:
        return 14.0;
      default:
        return 26.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultGradientColors = [
      theme.colorScheme.primary,
      theme.colorScheme.secondary,
    ];

    if (!useGradient) {
      return Text(
        text,
        style: TextStyle(
          fontSize: _getFontSize(),
          fontWeight: fontWeight,
          color: theme.colorScheme.onBackground,
          letterSpacing: letterSpacing,
        ),
        textAlign: textAlign,
      );
    }

    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: gradientColors ?? defaultGradientColors,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(bounds),
      child: Text(
        text,
        style: TextStyle(
          fontSize: _getFontSize(),
          fontWeight: fontWeight,
          color: Colors.white,
          letterSpacing: letterSpacing,
        ),
        textAlign: textAlign,
      ),
    );
  }
}

enum TextType {
  heading,    // For main headings (32px)
  subHeading, // For sub-headings (24px)
  title,      // For titles (20px)
  body,       // For body text (16px)
  caption,    // For captions (14px)
} 