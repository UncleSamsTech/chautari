// import 'package:flutter/material.dart';
// import 'package:tuktak/views/common_components/password_field.dart';
// import 'package:tuktak/views/common_components/primary_button.dart';

// class ChangePassword extends StatelessWidget {
//   const ChangePassword({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Change Password"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 "Current Password",
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//               ),
//               PasswordField(),
//               SizedBox(
//                 height: 14,
//               ),
//               Text("New Password",
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
//               PasswordField(),
//               SizedBox(
//                 height: 14,
//               ),
//               Text("Confirm New Password",
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
//               PasswordField(),
//               SizedBox(
//                 height: 24,
//               ),
//               PrimaryButton(label: "Change Password", onPressed: () {})
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:tuktak/services/auth_service.dart';
import 'package:tuktak/services/backend_interface.dart';
import 'package:tuktak/utils.dart';
import 'package:tuktak/views/common_components/password_field.dart';
import 'package:tuktak/views/common_components/primary_button.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();

  /// Validate password length
  String? _validatePasswordLength(String password) {
    if (password.length < 8 || password.length > 20) {
      return "Password must be 8-20 characters long";
    }
    return null;
  }

  /// Validate password special character constraints
  String? _validatePasswordSpecialChars(String password) {
    final hasLowercase = RegExp(r'[a-z]').hasMatch(password);
    final hasUppercase = RegExp(r'[A-Z]').hasMatch(password);
    final hasDigit = RegExp(r'\d').hasMatch(password);
    final hasSpecialChar =
        RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(password);

    if (!hasLowercase)
      return "Password must include at least one lowercase letter";
    if (!hasUppercase)
      return "Password must include at least one uppercase letter";
    if (!hasDigit) return "Password must include at least one number";
    if (!hasSpecialChar)
      return "Password must include at least one special character";
    return null;
  }

  void _handleChangePassword() async {
    if (_formKey.currentState!.validate()) {
      // Perform password change logic here

      try {
        await AuthService().changePassword(
            _currentPasswordController.text, _newPasswordController.text);
        showSucessToast(context, "Password changed successfully!");
        Navigator.of(context).pop();
      } on HttpException catch (e) {
        showErrorToast(context, e.message);
      } catch (e) {
        showErrorToast(context, e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Change Password"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Current Password",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                PasswordField(
                  controller: _currentPasswordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your current password";
                    }

                    final lengthError = _validatePasswordLength(value);
                    if (lengthError != null) return lengthError;

                    final specialCharError =
                        _validatePasswordSpecialChars(value);
                    if (specialCharError != null) return specialCharError;
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                const Text(
                  "New Password",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                PasswordField(
                  controller: _newPasswordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a new password";
                    }
                    if (value == _currentPasswordController.text) {
                      return "New password cannot be the same as the current password";
                    }
                    final lengthError = _validatePasswordLength(value);
                    if (lengthError != null) return lengthError;

                    final specialCharError =
                        _validatePasswordSpecialChars(value);
                    if (specialCharError != null) return specialCharError;

                    return null;
                  },
                ),
                const SizedBox(height: 14),
                const Text(
                  "Confirm New Password",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                PasswordField(
                  controller: _confirmPasswordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please confirm your new password";
                    }
                    if (value != _newPasswordController.text) {
                      return "New password and confirm password do not match";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                PrimaryButton(
                  label: "Change Password",
                  onPressed: _handleChangePassword,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
