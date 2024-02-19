// ignore_for_file: must_be_immutable, duplicate_import, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:pharmazool/src/core/utils/styles.dart';

class DefaultTextFormFieldForProblem extends StatelessWidget {
  Function validator;

  // Function? onChanged;
  final TextEditingController? textEditingController;
  final TextInputType textInputType;
  final String? hintText;
  final String? labelText;
  final int maxLines;
  Widget? prefixIcon;
  void Function()? onTap;
  bool? readOnly;

  DefaultTextFormFieldForProblem(
      {Key? key,
      required this.validator,
      this.labelText,
      this.prefixIcon,
      this.textEditingController,
      required this.textInputType,
      this.hintText,
      required this.maxLines,
      this.onTap,
      this.readOnly})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: TextFormField(
        validator: (value) => validator(value),
        onTap: onTap,
        textAlign: TextAlign.end,
        controller: textEditingController,
        keyboardType: textInputType,
        obscureText: false,
        readOnly: readOnly ?? false,
        cursorColor: Colors.white,
        style: TextStyles.styleblackDefault,
        maxLines: maxLines,
        decoration: InputDecoration(
            filled: true,
            prefixIcon: prefixIcon,
            hintText: hintText,
            labelText: labelText,
            // floatingLabelAlignment: FloatingLabelAlignment.center,
            hintStyle: TextStyles.styleteal,
            border:const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey))),
      ),
    );
  }
}
