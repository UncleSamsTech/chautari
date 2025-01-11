import 'package:tuktak/services/backend_interface.dart';
import 'package:tuktak/services/shared_preference_service.dart';
import 'package:tuktak/services/user_manager.dart';

import '../utils.dart';

class UserAvailability {
  final bool available;
  final String username;

  UserAvailability({
    required this.available,
    required this.username,
  });

  factory UserAvailability.fromJson(Map<String, dynamic> json) {
    return UserAvailability(
      available: json['available'],
      username: json['username'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'available': available,
      'username': username,
    };
  }
}

class AuthService {
  AuthService._privateConstructor(this.backendInterface);

  static final AuthService _instance =
      AuthService._privateConstructor(BackendInterface());

  factory AuthService() {
    return _instance;
  }

  final BackendInterface backendInterface;

  Future<String?> registerWithEmail(
      String email, String password, String userName) async {
    final body = {"email": email, "password": password, "username": userName};
    // Body modal
    // {
    //   "email":"email.com",
    //   "password":"password",
    //   "username":"username"
    // }
    final response =
        await backendInterface.post("auth/register/email", body: body);

    if (response.status == 200 || response.status == 201) return null;
    return response.message;
  }

  Future<void> loginWithEmail(String email, String password) async {
    final body = {"email": email, "password": password};
    // {
    // "email": "user@exa1mple.coqm",
    // "password": "password123#A"
    // }
    final response =
        await backendInterface.post("auth/login/email", body: body);
    if (response.status != 200) throw HttpException(message: response.message);
  }

  Future<void> logout() async {
    final _ = await backendInterface.delete("auth/logout");
    backendInterface.clearCookies();
    await SharedPreferenceService().setIsLogin(false);
    await SharedPreferenceService().removeCookie();
    UserManager().user = null;
  }

  Future<void> makeUserPersistence() async {
    print("Setting login true");
    await SharedPreferenceService().setIsLogin(true);
  }

  Future<bool> isUserAvailable(String userName) async {
    final backendInterface = BackendInterface();
    final response = await backendInterface
        .post("auth/check-username", body: {"username": userName});

    if (response.status != 200) {
      throw HttpException(message: response.message);
    }
    final userAvailability = UserAvailability.fromJson(response.data);

    return userAvailability.available;
  }

  Future<void> updateUserProfile(
      {String? name, String? email, String? bio}) async {
    final backendInterface = BackendInterface();

    Map<String, String> body = {};
    // body['name'] = name ?? "";
    if (name != null) body["name"] = name!;
    if (email != null) body["email"] = email!;
    if (bio != null) body["bio"] = bio!;

    if (body.isNotEmpty) {
      final response = await backendInterface.put("auth/profile", body: body);
    }
  }

  Future<void> changePassword(
      String currentPassword, String newPassword) async {
    final backendInterface = BackendInterface();

    final body = {
      "currentPassword": currentPassword,
      "newPassword": newPassword
    };

    final response =
        await backendInterface.put("auth/change-password", body: body);
    if (response.status != 200) throw HttpException(message: response.message);
  }

  Future<String> forgetPasswordByEmail(String email) async {
    final backendInterface = BackendInterface();

    final body = {"email": email};

    final response =
        await backendInterface.post("auth/forgot-password", body: body);

    return response.message;
  }

  Future<void> resendOtp(String email) async {
    final backendInterface = BackendInterface();
    final body = {"email": email};

    final response =
        await backendInterface.post("/auth/resend-otp", body: body);
    if (response.status != 200) throw HttpException(message: response.message);
  }

  Future<void> verifyOtpAndChangePassword(
      String email, String password, String otp) async {
    final backendInterface = BackendInterface();
    final body = {"email": email, "otp": otp, "newPassword": password};

    final response = await backendInterface
        .post("auth/verify-otp-reset-password", body: body);
    if (response.status != 200) throw HttpException(message: response.message);
  }
}
