import 'package:flutter/material.dart';
import 'package:tuktak/services/auth_service.dart';
import 'package:tuktak/services/backend_interface.dart';
import 'package:tuktak/utils.dart';
import 'package:tuktak/views/auth/password_creation.dart';
import 'package:tuktak/views/auth/register/user_registered.dart';
import 'package:tuktak/views/common_components/primary_button.dart';

import '../../../common_components/password_field.dart';

class RegisterSteps extends StatefulWidget {
  const RegisterSteps({super.key});

  @override
  State<RegisterSteps> createState() => _RegisterStepsState();
}

class _RegisterStepsState extends State<RegisterSteps> {
  final GlobalKey<FormState> _nameFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _emailFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _passwordFormKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  int currentIndex = 0;
  bool isLoading = false;
  String? errorMessage;

  Future<void> checkUserAvailability() async {
    setState(() {
      isLoading = true;
    });
    try {
      final isUserAvailable =
          await AuthService().isUserAvailable(nameController.text);

      if (!isUserAvailable) {
        setState(() {
          errorMessage = "Username ${nameController.text} is not available";
        });
        setState(() {
          isLoading = false;
        });
        return;
      } else {
        setState(() {
          errorMessage = null;
          isLoading = false;
          currentIndex++;
        });
      }
      setState(() {});
    } on HttpException catch (e) {
      setState(() {
        errorMessage = e.message;
        isLoading = false;
      });
      return;
    }
  }

  Future<void> submitTheRegister() async {
    setState(() {
      isLoading = true;
    });
    final message = await register();
    if (message != null) {
      showErrorToast(context, message);
      print("ERROR HERE: ${message}");
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const UserRegistered()),
        (route) => true,
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<String?> register() async {
    final authService = AuthService();

    final message = await authService.registerWithEmail(
        emailController.text, passwordController.text, nameController.text);
    if (message == null) {
      authService.makeUserPersistence();
    }
    return message;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding:
              EdgeInsets.only(top: MediaQuery.sizeOf(context).height * 0.03),
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator.adaptive(),
                )
              : Stepper(
                  connectorThickness: 2,
                  type: StepperType.horizontal,
                  currentStep: currentIndex,
                  elevation: 0,
                  onStepTapped: (step) {
                    if (step < currentIndex) {
                      setState(() {
                        currentIndex = step;
                      });
                    }
                  },
                  steps: [
                    Step(
                      title: Text(currentIndex == 0 ? "Register Name" : ""),
                      content: Form(
                        key: _nameFormKey,
                        child: buildRegisterName(),
                      ),
                      isActive: currentIndex >= 0,
                      state: currentIndex > 0
                          ? StepState.complete
                          : StepState.indexed,
                    ),
                    Step(
                      title: Text(currentIndex == 1 ? "Register Email" : ""),
                      content: Form(
                        key: _emailFormKey,
                        child: buildRegisterEmail(),
                      ),
                      isActive: currentIndex >= 1,
                      state: currentIndex > 1
                          ? StepState.complete
                          : StepState.indexed,
                    ),
                    Step(
                      title: Text(currentIndex == 2 ? "Create Password" : ""),
                      content: Form(
                        key: _passwordFormKey,
                        // child: buildCreatePassword(),
                        child: PasswordValidationWidget(
                            passwordController: passwordController),
                      ),
                      isActive: currentIndex >= 2,
                      state: currentIndex > 2
                          ? StepState.complete
                          : StepState.indexed,
                    ),
                  ],
                  controlsBuilder:
                      (BuildContext context, ControlsDetails details) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: PrimaryButton(
                            onPressed: () async {
                              if (validateCurrentStep()) {
                                if (currentIndex == 0) {
                                  checkUserAvailability();
                                  return;
                                }

                                if (currentIndex < 2) {
                                  setState(() {
                                    currentIndex++;
                                  });
                                } else {
                                  submitTheRegister();
                                }
                              }
                            },
                            label: currentIndex == 2 ? "Finish" : "Next",
                          ),
                        ),
                      ],
                    );
                  },
                ),
        ),
      ),
    );
  }

  Widget buildRegisterName() {
    const headingText = "What’s Your Name?";
    const headingStyle = TextStyle(fontSize: 24, fontWeight: FontWeight.w600);
    const subHeadingText =
        "Enter your unique username so that it is easily recognized";
    const subHeadingStyle = TextStyle(
        fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF667085));

    const columnGap = 24.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(headingText, style: headingStyle),
        const Text(subHeadingText, style: subHeadingStyle),
        const SizedBox(height: columnGap),
        TextFormField(
          controller: nameController,
          decoration: InputDecoration(
            hintText: "Enter your username...",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter username.";
            }
            return null;
          },
        ),
        if (errorMessage != null)
          Text(
            errorMessage!,
            style: TextStyle(color: Colors.red),
          ),
        const SizedBox(height: columnGap),
      ],
    );
  }

  Widget buildRegisterEmail() {
    const headingText = "Let's Connect!";
    const headingStyle = TextStyle(fontSize: 24, fontWeight: FontWeight.w600);
    const subHeadingText = "Enter your email so that we can connect";
    const subHeadingStyle = TextStyle(
        fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF667085));

    const columnGap = 24.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(headingText, style: headingStyle),
        const Text(subHeadingText, style: subHeadingStyle),
        const SizedBox(height: columnGap),
        TextFormField(
            controller: emailController,
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              hintText: "Email",
              suffixIcon: const Icon(Icons.email_outlined),
            ),
            validator: emailValidator),
        const SizedBox(
          height: columnGap,
        ),
      ],
    );
  }

  bool validateCurrentStep() {
    switch (currentIndex) {
      case 0:
        return _nameFormKey.currentState?.validate() ?? false;
      case 1:
        return _emailFormKey.currentState?.validate() ?? false;
      case 2:
        return _passwordFormKey.currentState?.validate() ?? false;
      default:
        return false;
    }
  }
}
