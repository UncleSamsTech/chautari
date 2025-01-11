


import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({super.key, this.validator,this.controller});
final String? Function(String?)? validator;
final TextEditingController? controller;
  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: isObscure,
      validator: widget.validator,
      controller: widget.controller,
      maxLength: 20,
      decoration: InputDecoration(
        hintText: "Password",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          
          suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  isObscure = !isObscure;
                });
              },
              icon: isObscure
                  ? Icon(Icons.visibility_sharp)
                  : Icon(Icons.visibility_off_sharp))),
    );
  }
}
