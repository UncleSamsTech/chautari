import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tuktak/views/auth/register/register.dart';
import 'package:tuktak/views/common_components/primary_button.dart';

class AskAccountCreation extends StatelessWidget {
  const AskAccountCreation({super.key});

  @override
  Widget build(BuildContext context) {
    // final backButton =
    //     IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_back_ios));
    const pageTitle = Text("Profile");

    final moreMenu = IconButton(
        onPressed: () {}, icon: const Icon(Icons.more_horiz_outlined));

    const userNotPresentIconPath = "assets/icons/use_not_present.svg";
    const message = "You don't have an account yet, please register first";
    const messageSize = 16.0;
    const columnGap = 24.0;
    const circleAvatarRadius = 45.0;

    return Scaffold(
      appBar: AppBar(
        // leading: backButton,
        title: pageTitle,
        centerTitle: true,
        actions: [moreMenu],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CircleAvatar(
              radius: circleAvatarRadius,
              child: SvgPicture.asset(
                userNotPresentIconPath,
                // color: Colors.black,
                colorFilter:
                    const ColorFilter.mode(Colors.black, BlendMode.srcIn),
              ),
            ),
            const Text(
              message,
              textAlign: TextAlign.center,
              style:
                  TextStyle(fontSize: messageSize, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: columnGap,
            ),
            PrimaryButton(label: "Create Account", onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const Register()));
            })
          ],
        ),
      ),
    );
  }
}
