
import 'package:flutter/material.dart';

import '../common_components/password_field.dart';

class PasswordValidationWidget extends StatefulWidget {
  final TextEditingController passwordController;

  const PasswordValidationWidget({super.key, required this.passwordController});

  @override
  _PasswordValidationWidgetState createState() =>
      _PasswordValidationWidgetState();
}

class _PasswordValidationWidgetState extends State<PasswordValidationWidget> {
  bool hasValidLength = false;
  bool hasSpecialChars = false;

  @override
  void initState() {
    super.initState();
    widget.passwordController.addListener(_validatePassword);
  }

  @override
  void dispose() {
    widget.passwordController.removeListener(_validatePassword);
    super.dispose();
  }

  void _validatePassword() {
    final password = widget.passwordController.text;

    setState(() {
      hasValidLength = password.length >= 8 && password.length <= 20;
      hasSpecialChars = RegExp(r'[a-z]').hasMatch(password) &&
          RegExp(r'[A-Z]').hasMatch(password) &&
          RegExp(r'\d').hasMatch(password) &&
          RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(password);
    });
  }

  @override
  Widget build(BuildContext context) {
    const headingText = "Create Password";
    const headingStyle = TextStyle(fontSize: 24, fontWeight: FontWeight.w600);
    const subHeadingText = "Make your password strong so it is safe!";
    const subHeadingStyle = TextStyle(
        fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF667085));

    const passwordConditionTitle = "Password must have:";
    const columnGap = 24.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(headingText, style: headingStyle),
        const Text(subHeadingText, style: subHeadingStyle),
        SizedBox(height: columnGap),
        PasswordField(
          controller: widget.passwordController,
          validator: (data) {
            if (!(hasSpecialChars && hasValidLength)) {
              return "Provide Strong pasword";
            }
            return null;
          },
        ),
        SizedBox(height: columnGap),
        const Text(passwordConditionTitle),
        Wrap(
          children: [
            Icon(
              hasValidLength ? Icons.check_circle : Icons.circle_outlined,
              color: hasValidLength ? Colors.green : Colors.grey,
            ),
            const SizedBox(width: 8),
            const Text("8 to 20 strong characters"),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(
              hasSpecialChars ? Icons.check_circle : Icons.circle_outlined,
              color: hasSpecialChars ? Colors.green : Colors.grey,
            ),
            const SizedBox(width: 8),
            const Text(
              "Strong letters, \nnumbers, and special characters",
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        SizedBox(
          height: columnGap,
        )
      ],
    );
  }
}
