import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:greenbill_merchant/src/ui/values/values.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType inputType;
  final List<TextInputFormatter> formatter;
  final bool hasFormatter;
  final TextStyle textFieldStyle;
  final TextStyle hintTextStyle;
  final EdgeInsets padding;
  final BorderStyle borderStyle;
  final double borderRadius;
  final double borderWidth;
  final double contentPaddingHorizontal;
  final double contentPaddingVertical;
  final IconData prefixIcon;
  final String hintText;
  final Color prefixIconColor;
  final Color borderColor;
  final Color focusedBorderColor;
  final Color enabledBorderColor;
  final Color fillColor;
  final bool filled;
  final bool obscured;
  final bool hasPrefixIcon;
  final int maxLines;
  final Function onTap ;
  final int maxLength;

  CustomTextField({
    this.controller,
    this.inputType = TextInputType.text,
    this.formatter,
    this.hasFormatter = false,
    this.textFieldStyle = Styles.boldTextStyle,
    this.hintTextStyle = Styles.normalTextStyle,
    this.padding,
    this.borderStyle = BorderStyle.none,
    this.borderRadius = Sizes.RADIUS_12,
    this.borderWidth = Sizes.WIDTH_0,
    this.contentPaddingHorizontal = Sizes.PADDING_4,
    this.contentPaddingVertical = Sizes.PADDING_10,
    this.prefixIcon,
    this.hintText,
    this.prefixIconColor = AppColors.kPrimaryColorBlue,
    this.borderColor = AppColors.kPrimaryColorBlue,
    this.focusedBorderColor = AppColors.kPrimaryColorBlue,
    this.enabledBorderColor = AppColors.kPrimaryColorBlue,
    this.fillColor,
    this.filled = true,
    this.obscured = false,
    this.hasPrefixIcon = true,
    this.maxLines,
    this.onTap,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      child: TextField(
        controller: controller,
        keyboardType: inputType,
        style: textFieldStyle,
        maxLines: maxLines,
        maxLength: maxLength,
        inputFormatters: formatter,
        onTap: onTap,
        decoration: InputDecoration(
          counterStyle: TextStyle(height: double.minPositive,),
          counterText: "",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              color: borderColor,
              width: borderWidth,
              style: borderStyle,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              color: enabledBorderColor,
              width: borderWidth,
              style: borderStyle,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              color: focusedBorderColor,
              width: borderWidth,
              style: borderStyle,
            ),
          ),
          prefixIcon: hasPrefixIcon ?
          Icon(
            prefixIcon,
            color: prefixIconColor,
          ): null,
          contentPadding: EdgeInsets.symmetric(
            horizontal: contentPaddingHorizontal,
            vertical: contentPaddingVertical,
          ),
          hintText: hintText,
          hintStyle: hintTextStyle,
          filled: filled,
          fillColor: fillColor,
        ),
        obscureText: obscured,
      ),
    );
  }
}
