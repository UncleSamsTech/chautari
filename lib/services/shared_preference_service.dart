import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceService {
  SharedPreferenceService._privateConstructor();

  static final SharedPreferenceService _instance =
      SharedPreferenceService._privateConstructor();

  factory SharedPreferenceService() {
    return _instance;
  }

  String? cookies;
  late bool isLogin;

  Future<void> load() async {
    final pref = await SharedPreferences.getInstance();
    cookies = pref.getString('cookie');
    isLogin = pref.getBool('isLogin') ?? false;
  }

  Future<void> setCookie(String cookie) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString('cookie', cookie);
    cookies = cookie;
  }

  Future<void> removeCookie() async {
    final pref = await SharedPreferences.getInstance();
    await pref.remove('cookie');
    cookies = null;
  }

  Future<void> setIsLogin(bool status) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setBool('isLogin', status);
    isLogin = status;
  }
}
