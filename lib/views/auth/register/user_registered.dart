import 'package:flutter/material.dart';
import 'package:tuktak/views/common_components/primary_button.dart';
import 'package:tuktak/views/home.dart';
import 'package:tuktak/wrapper.dart';

import '../login/login.dart';

class UserRegistered extends StatelessWidget {
  const UserRegistered({super.key});

  @override
  Widget build(BuildContext context) {
    const headingText = "Your account is successfully created!";
    const headingStyle = TextStyle(fontSize: 24, fontWeight: FontWeight.w600);
    const subHeadingText =
        "Your account has been successfully created, please log in first so you can start viewing videos";
    const subHeadingStyle = TextStyle(
        fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF667085));

    const horizontalPadding = 24.0;
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(),
            Text(
              headingText,
              textAlign: TextAlign.center,
              style: headingStyle,
            ),
            SizedBox(
              height: 12,
            ),
            Text(
              subHeadingText,
              textAlign: TextAlign.center,
              style: subHeadingStyle,
            ),
            Spacer(),
            PrimaryButton(
                label: "Get Started",
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => Wrapper()),
                    (route) => false,
                  );
                }),
            SizedBox(
              height: 24,
            )
          ],
        ),
      )),
    );
  }
}
