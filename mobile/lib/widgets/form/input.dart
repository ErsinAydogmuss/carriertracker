import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_color.dart';
import '../../constants/constants.dart';

class FormInput extends StatefulWidget {
  final String labelText;
  final double? labelFontSize;
  final String hintText;
  final double? hintFontSize;
  final double? fontSize;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  bool? isObscureText;
  bool? isDisabled;
  Function? onTap;
  Function? onChanged;
  FocusNode? focusNode;

  FormInput({
    super.key,
    required this.labelText,
    this.labelFontSize,
    required this.hintText,
    this.hintFontSize,
    this.fontSize,
    required this.controller,
    required this.keyboardType,
    this.isObscureText = false,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.isDisabled = false,
    this.onTap,
    this.onChanged,
    this.focusNode,
  });

  @override
  FormInputState createState() => FormInputState();
}

class FormInputState extends State<FormInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColor(mainColor),
          width: 1.5,
        ),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: TextFormField(
        onTap: () {
          if (widget.onTap != null) {
            widget.onTap!();
          }
        },
        onChanged: (value) {
          if (widget.onChanged != null) {
            widget.onChanged!(value);
          }
        },
        focusNode: widget.focusNode,
        controller: widget.controller,
        obscureText: widget.isObscureText!,
        keyboardType: widget.keyboardType,
        validator: widget.validator,
        enabled: !widget.isDisabled!,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.zero,
          border: InputBorder.none,
          labelText: widget.labelText,
          labelStyle: GoogleFonts.inconsolata(
            textStyle: TextStyle(
              color: AppColor(mainColor),
              fontSize: widget.labelFontSize ?? mediumFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          hintText: widget.hintText,
          hintStyle: GoogleFonts.inconsolata(
            textStyle: TextStyle(
              letterSpacing: 1,
              color: AppColor(hintColor),
              fontSize: widget.hintFontSize ?? mediumFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          prefixIcon: widget.prefixIcon != null
              ? Icon(
            widget.prefixIcon,
            color: AppColor(mainColor),
            size: 25,
          )
              : null,
          suffixIcon: widget.suffixIcon != null
              ? GestureDetector(
            onTap: () {
              setState(() {
                widget.isObscureText = !widget.isObscureText!;
              });
            },
            child: Icon(
              !widget.isObscureText!
                  ? Icons.visibility
                  : Icons.visibility_off,
              color: AppColor(mainColor),
              size: 20,
            ),
          )
              : null,
        ),
        style: GoogleFonts.inconsolata(
          color: AppColor(blackColor),
          letterSpacing: !widget.isObscureText! ? 1 : 0,
          fontSize: widget.fontSize ?? mediumFontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
