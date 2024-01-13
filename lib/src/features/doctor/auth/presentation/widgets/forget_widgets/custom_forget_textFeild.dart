import 'package:pharmazool/src/core/config/routes/app_imports.dart';

class CustomForgetTextField extends StatelessWidget {
  const CustomForgetTextField(
      {super.key,
      required this.controller,
      this.labelText,
      this.validator,
      this.keyboardType,
      this.maxLines = 1,
      });

  final TextEditingController controller;
  final String? labelText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
 final int maxLines;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: TextFormField(
        controller: controller,
        cursorColor: Colors.lightBlue,
        validator: validator,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.numbers, color: Colors.black),
          labelText: labelText,
          labelStyle: const TextStyle(color: Colors.black),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: AppColors.PharmaColor),
            borderRadius: BorderRadius.circular(20.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: AppColors.PharmaColor),
            borderRadius: BorderRadius.circular(20.0),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
      ),
    );
  }
}
