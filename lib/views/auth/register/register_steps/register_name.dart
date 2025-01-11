import 'package:flutter/material.dart';
import 'package:tuktak/views/auth/register/register_steps/register_dob.dart';
import 'package:tuktak/views/common_components/primary_button.dart';

class RegisterName extends StatelessWidget {
  const RegisterName({super.key});

  @override
  Widget build(BuildContext context) {
    final backButton =
        IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_back_ios));

    const pageStatusText = "Step 1 of 5";
    const pageStatusTextStyle = TextStyle(color: Color(0xff94A3B8));

    const headingText = "What’s Your Name?";
    const headingStyle = TextStyle(fontSize: 24, fontWeight: FontWeight.w600);
    const subHeadingText = "Enter your name so that it is easily recognized";
    const subHeadingStyle = TextStyle(
        fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF667085));

    const columnGap = 24.0;
    const horizontalPadding = 24.0;

    const hintText = "Enter your full name....";

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
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8))),
            )),
            const SizedBox(
              height: columnGap,
            ),
            PrimaryButton(
                label: "Next",
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => RegisterDob()));
                })
          ],
        ),
      ),
    );
  }
}
