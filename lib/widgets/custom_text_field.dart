import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool obscureText;
  final bool readOnly;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final VoidCallback? onSuffixTap;
  final String? initialValue;
  final bool expands;
  final bool showCounter;
  final bool enabled;
  final TextCapitalization textCapitalization;
  final InputBorder? border;
  final Color? fillColor;
  final EdgeInsetsGeometry? contentPadding;

  const CustomTextField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.readOnly = false,
    this.keyboardType,
    this.textInputAction,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.validator,
    this.onChanged,
    this.onTap,
    this.onSuffixTap,
    this.initialValue,
    this.expands = false,
    this.showCounter = false,
    this.enabled = true,
    this.textCapitalization = TextCapitalization.none,
    this.border,
    this.fillColor,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final effectiveMaxLines = expands ? null : maxLines;
    return TextFormField(
      controller: controller,
      initialValue: initialValue,
      obscureText: obscureText,
      readOnly: readOnly,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      maxLines: effectiveMaxLines,
      minLines: minLines,
      maxLength: maxLength,
      validator: validator,
      onChanged: onChanged,
      onTap: onTap,
      enabled: enabled,
      expands: expands,
      textCapitalization: textCapitalization,
      style: TextStyle(
        fontSize: 15,
        color: colors.textPrimary,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        filled: true,
        fillColor: fillColor ?? colors.card,
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: colors.textSecondary, size: 20)
            : null,
        suffixIcon: suffixIcon != null
            ? InkWell(
                onTap: onSuffixTap,
                child: Icon(suffixIcon, color: colors.textSecondary, size: 20),
              )
            : null,
        counterText: showCounter ? null : '',
        contentPadding: contentPadding,
        border: border,
      ),
    );
  }
}
