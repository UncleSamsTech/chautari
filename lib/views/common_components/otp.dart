// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:tuktak/services/auth_service.dart';
// import 'package:tuktak/views/auth/register/register_steps/create_password.dart';
// import 'package:tuktak/views/common_components/primary_button.dart';

// class OtpVerification extends StatelessWidget {
//   OtpVerification({super.key, required this.email, required this.newPassword});

//   final String email;
//   final String newPassword;

//   final TextEditingController otpController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     final backButton =
//         IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_back_ios));

//     const horizontalPadding = 24.0;

//     const headingText = "Enter the 6 digit code";
//     const headingStyle = TextStyle(fontSize: 24, fontWeight: FontWeight.w600);
//     const subHeadingText = "The otp code will be sent to ";
//     const subHeadingStyle = TextStyle(
//         fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF667085));

//     return Scaffold(
//       appBar: AppBar(),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Text(headingText, style: headingStyle),
//             Text(
//               subHeadingText,
//               style: subHeadingStyle,
//             ),

//             SizedBox(height: 20),
//             // OTP Input Field
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: List.generate(6, (index) {
//                 return SizedBox(
//                   width: 50,
//                   child: TextField(
//                     keyboardType: TextInputType.number,
//                     textAlign: TextAlign.center,
//                     maxLength: 1,
//                     decoration: InputDecoration(
//                       counterText: '',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     onChanged: (value) {
//                       if (value.isNotEmpty && index < 5) {
//                         FocusScope.of(context).nextFocus();
//                       } else if (value.isEmpty && index > 0) {
//                         FocusScope.of(context).previousFocus();
//                       }
//                     },
//                   ),
//                 );
//               }),
//             ),
//             SizedBox(height: 20),
//             // Verify Button
//             ResendTimer(),
//             SizedBox(height: 20),
//             PrimaryButton(label: "Change password", onPressed: () async{
// AuthService().verifyOtpAndChangePassword(email, newPassword, )
//             })
//           ],
//         ),
//       ),
//     );
//   }
// }

// class ResendTimer extends StatefulWidget {
//   const ResendTimer({super.key});

//   @override
//   State<ResendTimer> createState() => _TimerState();
// }

// class _TimerState extends State<ResendTimer> {
//   final message = "Resend code ";
//   final messageStyle =
//       TextStyle(color: Color(0xff64748B), fontWeight: FontWeight.w400);

//   int totalWaitSec = 60;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     startTimer();
//   }

//   void startTimer() {
//     Timer.periodic(Duration(seconds: 1), (timer) {
//       if (totalWaitSec == 0) {
//         timer.cancel();
//       } else {
//         setState(() {
//           totalWaitSec = totalWaitSec - 1;
//         });
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Text(
//           message,
//           style: messageStyle,
//         ),
//         Text("${totalWaitSec} sec")
//       ],
//     );
//   }
// }
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tuktak/services/auth_service.dart';
import 'package:tuktak/services/backend_interface.dart';
import 'package:tuktak/views/auth/register/register_steps/create_password.dart';
import 'package:tuktak/views/common_components/primary_button.dart';

class OtpVerification extends StatefulWidget {
  final String email;
  final String newPassword;

  const OtpVerification({
    Key? key,
    required this.email,
    required this.newPassword,
  }) : super(key: key);

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  final List<TextEditingController> _otpControllers =
      List.generate(6, (_) => TextEditingController());
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  String get _otpCode =>
      _otpControllers.map((controller) => controller.text).join();

  Future<void> _verifyOtp() async {
    if (_otpCode.length < 6 || _otpCode.contains(RegExp(r'[^0-9]'))) {
      _showSnackBar("Please enter a valid 6-digit OTP.");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _authService.verifyOtpAndChangePassword(
        widget.email,
        widget.newPassword,
        _otpCode,
      );
      _showSnackBar("OTP Verified Successfully!");
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => const ),
      // );
    } on HttpException catch (e) {
      _showSnackBar(e.message);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    const horizontalPadding = 24.0;

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Enter the 6 digit code",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ),
            const Text(
              "The OTP code has been sent to your email.",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF667085),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (index) {
                return SizedBox(
                  width: 50,
                  child: TextField(
                    controller: _otpControllers[index],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    decoration: InputDecoration(
                      counterText: '',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty && index < 5) {
                        FocusScope.of(context).nextFocus();
                      } else if (value.isEmpty && index > 0) {
                        FocusScope.of(context).previousFocus();
                      }
                    },
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
            const ResendTimer(),
            const SizedBox(height: 20),
            PrimaryButton(
              label: _isLoading ? "Verifying..." : "Change Password",
              // onPressed: _isLoading
              //     ? null
              //     : () async {
              //         await _verifyOtp();
              //       },
              onPressed: _isLoading
                  ? () {}
                  : () async {
                      await _verifyOtp();
                    },
            ),
          ],
        ),
      ),
    );
  }
}

// class ResendTimer extends StatefulWidget {
//   const ResendTimer({super.key});

//   @override
//   State<ResendTimer> createState() => _ResendTimerState();
// }

// class _ResendTimerState extends State<ResendTimer> {
//   final int _totalWaitSec = 60;
//   int _remainingSec = 60;

//   @override
//   void initState() {
//     super.initState();
//     _startTimer();
//   }

//   void _startTimer() {
//     Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (_remainingSec == 0) {
//         timer.cancel();
//       } else {
//         setState(() {
//           _remainingSec--;
//         });
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         const Text(
//           "Resend code in ",
//           style:
//               TextStyle(color: Color(0xff64748B), fontWeight: FontWeight.w400),
//         ),
//         Text("$_remainingSec sec"),
//       ],
//     );
//   }
// }

class ResendTimer extends StatefulWidget {
  const ResendTimer({super.key});

  @override
  State<ResendTimer> createState() => _ResendTimerState();
}

class _ResendTimerState extends State<ResendTimer> {
  final int _totalWaitSec = 60;
  int _remainingSec = 60;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSec == 0) {
        timer.cancel();
      } else {
        setState(() {
          _remainingSec--;
        });
      }
    });
  }

  void _resendOtp() {
    // Logic for resending the OTP
    setState(() {
      _remainingSec = _totalWaitSec;
    });
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (_remainingSec > 0) ...[
          const Text(
            "Resend code in ",
            style: TextStyle(
                color: Color(0xff64748B), fontWeight: FontWeight.w400),
          ),
          Text("$_remainingSec sec"),
        ] else ...[
          TextButton(
            onPressed: _resendOtp,
            child: const Text(
              "Resend OTP",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ],
    );
  }
}
