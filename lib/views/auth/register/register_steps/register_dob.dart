import 'package:flutter/material.dart';
import 'package:tuktak/views/auth/register/register_steps/register_phone_email.dart';
import 'package:tuktak/views/common_components/primary_button.dart';

class RegisterDob extends StatelessWidget {
  const RegisterDob({super.key});

  @override
  Widget build(BuildContext context) {
    final backButton =
        IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_back_ios));

    const pageStatusText = "Step 2 of 5";
    const pageStatusTextStyle = TextStyle(color: Color(0xff94A3B8));

    const headingText = "What is your date of birth?";
    const headingStyle = TextStyle(fontSize: 24, fontWeight: FontWeight.w600);
    const subHeadingText =
        "Don't worry, your date of birth will not appear in public";
    const subHeadingStyle = TextStyle(
        fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF667085));

    const columnGap = 24.0;
    const horizontalPadding = 24.0;

    const hintText = "Enter your date of birth";

    return Scaffold(
      appBar: AppBar(
        leading: backButton,
        actions: const [
          Text(
            pageStatusText,
            style: pageStatusTextStyle,
          ),
          SizedBox(
            width: 12,
          )
        ],
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
              height: columnGap,
            ),
            Form(
                child: TextFormField(
              decoration: InputDecoration(
                  hintText: hintText,
                  suffixIcon: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.calendar_month_outlined)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8))),
            )),
            const SizedBox(
              height: columnGap,
            ),
            PrimaryButton(
                label: "Next",
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => RegisterPhoneEmail()));
                })
          ],
        ),
      ),
    );
  }
}
