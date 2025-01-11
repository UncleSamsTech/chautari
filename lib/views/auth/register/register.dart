import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tuktak/views/auth/login/login.dart';
import 'package:tuktak/views/auth/register/register_steps/register_name.dart';
import 'package:tuktak/views/auth/register/register_steps/register_steps.dart';
import 'package:tuktak/views/common_components/secondary_buttton.dart';

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    final backButton = IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: const Icon(Icons.arrow_back_ios));

    const headingText = "Register";
    const headingStyle = TextStyle(fontSize: 24, fontWeight: FontWeight.w600);
    const subHeadingText =
        "Please select several options to register your account at SocialMedia";
    const subHeadingStyle = TextStyle(
        fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF667085));

    const phoneOrEmailBtnText = "Use phone number or email";
    const googleBtnText = "Continue with google";
    const googleIconPath = "assets/icons/google.svg";

    const columnSpacing = 24.0;
    const rowSpacing = 8.0;
    const horizontalPadding = 24.0;

    const alreadyAccount = "Already have an account?";
    const alreadyAccountStyle = TextStyle(color: Color(0xff98a2b3));
    const loginBtnText = "Login";

    return Scaffold(
      appBar: AppBar(
        leading: backButton,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              headingText,
              style: headingStyle,
            ),
            const Text(
              subHeadingText,
              style: subHeadingStyle,
            ),
            const SizedBox(
              height: columnSpacing * 1.5,
            ),
            SecondaryButtton(
              label: phoneOrEmailBtnText,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const RegisterSteps()));
              },
              icon: const Icon(Icons.person),
            ),
            const SizedBox(
              height: columnSpacing,
            ),
            SecondaryButtton(
              label: googleBtnText,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const RegisterName()));
              },
              icon: SvgPicture.asset(googleIconPath),
            ),
            const SizedBox(
              height: columnSpacing * 1.5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  alreadyAccount,
                  style: alreadyAccountStyle,
                ),
                const SizedBox(
                  width: rowSpacing,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => Login()));
                    },
                    child: const Text(loginBtnText))
              ],
            )
          ],
        ),
      ),
    );
  }
}
