import 'package:flutter/material.dart';
import 'package:tuktak/views/auth/register/user_registered.dart';
import 'package:tuktak/views/common_components/primary_button.dart';

import '../../../common_components/password_field.dart';

class CreatePassword extends StatelessWidget {
  const CreatePassword({super.key});

  @override
  Widget build(BuildContext context) {
    final backButton =
        IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_back_ios));

    const horizontalPadding = 24.0;

    const headingText = "Create password";
    const headingStyle = TextStyle(fontSize: 24, fontWeight: FontWeight.w600);
    const subHeadingText = "Make your password strong so it is safe!";
    const subHeadingStyle = TextStyle(
        fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF667085));

    const passwordConditionTitle = "Password must have:";

    final conditions = [
      "8 to 20 strong characters",
      "Strong letters, numbers, and special characters"
    ];
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              headingText,
              style: headingStyle,
            ),
            Text(
              subHeadingText,
              style: subHeadingStyle,
            ),
            PasswordField(),
            Text(passwordConditionTitle),
            ...conditions.map((e) => Text(e)).toList(),
            PrimaryButton(
                label: "Next",
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => UserRegistered()));
                })
          ],
        ),
      ),
    );
  }
}
