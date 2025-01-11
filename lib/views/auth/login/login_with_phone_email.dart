import 'package:flutter/material.dart';
import 'package:tuktak/services/backend_interface.dart';
import 'package:tuktak/utils.dart';
import 'package:tuktak/views/auth/forget_password/ask_email.dart';
import 'package:tuktak/views/auth/register/register_steps/create_password.dart';
import 'package:tuktak/views/common_components/primary_button.dart';
import 'package:tuktak/views/home.dart';
import 'package:tuktak/wrapper.dart';

import '../../../services/auth_service.dart';
import '../../common_components/password_field.dart';
import '../../common_components/phone_number_field.dart';
import '../../common_components/tab_toggle.dart';

class LoginWithPhoneEmail extends StatelessWidget {
  LoginWithPhoneEmail({super.key});
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> _emailFormKey = GlobalKey<FormState>();

  final PageController pageController = PageController();

  Future<void> logInWithEmail() async {
    final authService = AuthService();

    final _ = await authService.loginWithEmail(
        emailController.text, passwordController.text);
    await authService.makeUserPersistence();
  }

  @override
  Widget build(BuildContext context) {
    final backButton = IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: const Icon(Icons.arrow_back_ios));

    const horizontalPadding = 24.0;

    const headingText = "Enjoy Your Favorite Moments";
    const headingStyle = TextStyle(fontSize: 24, fontWeight: FontWeight.w600);
    const subHeadingText = "Log in to start exploring endless entertainment.";
    const subHeadingStyle = TextStyle(
        fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF667085));

    return Scaffold(
      appBar: AppBar(
        leading: backButton,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              headingText,
              style: headingStyle,
            ),
            const Text(
              subHeadingText,
              style: subHeadingStyle,
            ),
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
              height: MediaQuery.sizeOf(context).height * 0.03,
            ),
            Expanded(
              child: Form(
                child: PageView(
                  physics: const NeverScrollableScrollPhysics(),
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
        const SizedBox(
          height: 24,
        ),
        const PasswordField(),
        const SizedBox(
          height: 24,
        ),
        PrimaryButton(label: "Login", onPressed: () {})
      ],
    );
  }

  Widget buildEmailRegisterField(BuildContext context) {
    return Form(
      key: _emailFormKey,
      child: Column(
        children: [
          TextFormField(
            controller: emailController,
            validator: emailValidator,
            decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                hintText: "Email",
                suffixIcon: const Icon(Icons.email_outlined)),
          ),
          const SizedBox(
            height: 24,
          ),
          PasswordField(
            controller: passwordController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter your password.";
              }
              return null;
            },
          ),
          const SizedBox(
            height: 24,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => AskEmail()));
                  },
                  child: Text("Forget Password?"))
            ],
          ),
          // PrimaryButton(
          //     label: "Login",
          //     onPressed: () async {
          //       if (_emailFormKey.currentState?.validate() ?? false) {
          //         try {
          //           await logInWithEmail();
          //           Navigator.of(context).pushAndRemoveUntil(
          //             MaterialPageRoute(builder: (context) => Wrapper()),
          //             (route) => true,
          //           );
          //         } on HttpException catch (e) {
          //           showErrorToast(context, e.message);
          //         }
          //       }
          //     })
          PrimaryButton(
            label: "Login",
            onPressed: () async {
              if (_emailFormKey.currentState?.validate() ?? false) {
                try {
                  await logInWithEmail();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => Wrapper()),
                    (route) => false, // Remove all previous routes
                  );
                } on HttpException catch (e) {
                  showErrorToast(context, e.message);
                }
              }
            },
          )
        ],
      ),
    );
  }
}
