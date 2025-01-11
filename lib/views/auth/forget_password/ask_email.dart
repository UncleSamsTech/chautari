import 'package:flutter/material.dart';
import 'package:tuktak/services/auth_service.dart';
import 'package:tuktak/services/backend_interface.dart';
import 'package:tuktak/views/auth/forget_password/ask_new_password.dart';
import 'package:tuktak/views/common_components/otp.dart';
import 'package:tuktak/views/common_components/primary_button.dart';

import '../../../utils.dart';

class AskEmail extends StatelessWidget {
  AskEmail({super.key});
  final emailController = TextEditingController();
  final globalFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    const horizontalPadding = 24.0;

    const headingText = "Enjoy Your Favorite Moments";
    const headingStyle = TextStyle(fontSize: 24, fontWeight: FontWeight.w600);
    const subHeadingText = "Log in to start exploring endless entertainment.";
    const subHeadingStyle = TextStyle(
        fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF667085));

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              headingText,
              style: headingStyle,
            ),
            Text(
              subHeadingText,
              style: subHeadingStyle,
            ),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.05,
            ),
            Form(
              key: globalFormKey,
              child: TextFormField(
                controller: emailController,
                validator: emailValidator,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    hintText: "Email",
                    suffixIcon: const Icon(Icons.email_outlined)),
              ),
            ),
            SizedBox(
              height: 24,
            ),
            PrimaryButton(
                label: "Next",
                onPressed: () async {
                  if (globalFormKey.currentState != null &&
                      globalFormKey.currentState!.validate()) {
                    try {
                      await AuthService().resendOtp(emailController.text);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              AskNewPassword(email: emailController.text)));
                    } on HttpException catch (e) {
                      showErrorToast(context, e.message);
                    }
                  }
                })
          ],
        ),
      ),
    );
  }
}
