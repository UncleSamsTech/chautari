import 'package:flutter/material.dart';
import 'package:tuktak/views/common_components/otp.dart';
import 'package:tuktak/views/common_components/phone_number_field.dart';
import 'package:tuktak/views/common_components/primary_button.dart';

import '../../../common_components/tab_toggle.dart';

class RegisterPhoneEmail extends StatelessWidget {
  RegisterPhoneEmail({super.key});

  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final backButton =
        IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_back_ios));

    const pageStatusText = "Step 3 of 5";
    const pageStatusTextStyle = TextStyle(color: Color(0xff94A3B8));

    const horizontalPadding = 24.0;

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
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.05,
            ),
            TabToggle(
              onChange: (index) {
                pageController.animateToPage(index,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut);
              },
            ),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.1,
            ),
            Expanded(
              child: Form(
                child: PageView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: pageController,
                  children: [
                    buildPhoneRegisterField(context),
                    buildEmailRegisterField(context)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPhoneRegisterField(BuildContext context) {
    return Column(
      children: [
        PhoneNumberField(
          phoneNumberController: phoneNumberController,
        ),
        SizedBox(
          height: 24,
        ),
        PrimaryButton(
            label: "Send Code",
            onPressed: () {
              // Navigator.of(context).push(MaterialPageRoute(
              //     builder: (context) => RegisterVerification(
              //           isNumber: true,
              //           mailOrNumber: " ${phoneNumberController.text}",
              //         )));
            })
      ],
    );
  }

  Widget buildEmailRegisterField(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: emailController,
          decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              hintText: "Email",
              suffixIcon: Icon(Icons.email_outlined)),
        ),
        SizedBox(
          height: 24,
        ),
        PrimaryButton(
            label: "Send Code",
            onPressed: () {
              // Navigator.of(context).push(MaterialPageRoute(
              //     builder: (context) => RegisterVerification(
              //           isNumber: false,
              //           mailOrNumber: emailController.text,
              //         )));
            })
      ],
    );
  }
}
