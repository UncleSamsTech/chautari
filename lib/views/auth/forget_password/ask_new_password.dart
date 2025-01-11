import 'package:flutter/material.dart';
import 'package:tuktak/services/auth_service.dart';
import 'package:tuktak/views/auth/password_creation.dart';
import 'package:tuktak/views/common_components/otp.dart';
import 'package:tuktak/views/common_components/primary_button.dart';

class AskNewPassword extends StatelessWidget {
  AskNewPassword({super.key, required this.email});
  final String email;
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              PasswordValidationWidget(passwordController: passwordController),
              SizedBox(
                height: 24,
              ),
              PrimaryButton(
                  label: "Next",
                  onPressed: () {
                    if (formKey.currentState != null &&
                        formKey.currentState!.validate()) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => OtpVerification(
                                email: email,
                                newPassword: passwordController.text,
                              )));
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
