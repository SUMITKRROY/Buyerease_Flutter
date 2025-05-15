import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType keyboardType;
  final int? maxLength;
  final int? maxLines;
  final bool enabled;
  final TextInputAction textInputAction;
  final FocusNode? focusNode;
  final void Function(String)? onChanged;
  final void Function()? onEditingComplete;
  final void Function(String)? onFieldSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final String? counterText;
  final bool showCounter;
  final String? errorText;
  final Widget? suffixIcon;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    this.prefixIcon = Icons.code,
    this.validator,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.maxLength,
    this.maxLines = 1,
    this.enabled = true,
    this.textInputAction = TextInputAction.done,
    this.focusNode,
    this.onChanged,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.inputFormatters,
    this.counterText,
    this.showCounter = true,
    this.errorText,
    this.suffixIcon,
  });

  List<TextInputFormatter> _getInputFormatters() {
    final List<TextInputFormatter> formatters = [];
    
    // Add length limiting formatter with default value of 40 if maxLength is not specified
    formatters.add(LengthLimitingTextInputFormatter(maxLength ?? 40));
    
    // Add any additional formatters if provided
    if (inputFormatters != null) {
      formatters.addAll(inputFormatters!);
    }
    
    return formatters;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      //maxLength: maxLength ?? 40, // Default to 40 if not specified
      maxLines: maxLines,
      enabled: enabled,
      textInputAction: textInputAction,
      focusNode: focusNode,
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
      onFieldSubmitted: onFieldSubmitted,
      inputFormatters: _getInputFormatters(),
      style: TextStyle(
        color: theme.colorScheme.onBackground,
        fontSize: 14.sp,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: theme.colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: theme.colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: theme.colorScheme.error),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: theme.colorScheme.outline.withOpacity(0.5)),
        ),
        prefixIcon: Icon(prefixIcon, color: theme.colorScheme.primary),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: enabled 
            ? theme.colorScheme.surface 
            : theme.colorScheme.surface.withOpacity(0.5),
        contentPadding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
        hintStyle: TextStyle(
          color: theme.colorScheme.onSurface.withOpacity(0.6),
          fontSize: 14.sp,
        ),
        counterText: showCounter ? counterText : null,
        errorText: errorText,
        errorStyle: TextStyle(
          color: theme.colorScheme.error,
          fontSize: 12.sp,
        ),
        counterStyle: TextStyle(
          color: theme.colorScheme.onSurface.withOpacity(0.6),
          fontSize: 12.sp,
        ),
      ),
      validator: validator,
    );
  }
} 