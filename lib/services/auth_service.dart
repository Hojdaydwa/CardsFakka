import 'package:flutter/foundation.dart';

class AuthService extends ChangeNotifier {
  bool _isLoading = true;
  bool _isLoggedIn = false;
  String _msisdn = '';
  String _statusText = 'جاري التحميل...';

  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;
  String get msisdn => _msisdn;
  String get statusText => _statusText;

  Future<void> login() async {
    _isLoading = true;
    _statusText = 'جاري تسجيل الدخول...';
    notifyListeners();

    try {
      // محاكاة تسجيل الدخول - استبدل ده بالـ API call الفعلي
      await Future.delayed(const Duration(seconds: 2));

      _isLoggedIn = true;
      _msisdn = '010xxxxxxxx';
      _statusText = 'متصل 🟢';
    } catch (e) {
      _statusText = 'فشل الاتصال 🔴';
      _isLoggedIn = false;
    }

    _isLoading = false;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _msisdn = '';
    _statusText = 'تم تسجيل الخروج';
    notifyListeners();
  }
}
