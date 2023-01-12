import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final TextInputType textInputType;
  final String hintText;
  final bool isPassword;
  final int maxLine;

  const TextFieldInput({
    Key? key,
    required this.textEditingController,
    required this.textInputType,
    required this.hintText,
    this.isPassword = false,
    this.maxLine = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textFieldBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context),
      borderRadius: BorderRadius.circular(18.0),
    );

    return TextField(
      controller: textEditingController,
      keyboardType: textInputType,
      obscureText: isPassword,
      maxLines: maxLine,
      decoration: InputDecoration(
        fillColor: Colors.white12,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        hintText: hintText,
        border: textFieldBorder,
        focusedBorder: textFieldBorder,
        enabledBorder: textFieldBorder,
        filled: true,
      ),
    );
  }
}
