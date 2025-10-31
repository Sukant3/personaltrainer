import 'package:flutter/material.dart';

class AuthViewModel extends ChangeNotifier {
  String? _phone;
  String? _otp;
  bool _isLoggedIn = false;

  String? get phone => _phone;
  bool get isLoggedIn => _isLoggedIn;

  void setPhone(String phone) {
    _phone = phone;
    notifyListeners();
  }

  void setOtp(String otp) {
    _otp = otp;
    notifyListeners();
  }

  Future<bool> verifyOtp() async {
    // Simulate OTP verification (replace with your backend later)
    await Future.delayed(const Duration(seconds: 1));
    if (_otp == '1234') {
      _isLoggedIn = true;
      notifyListeners();
      return true;
    }
    return false;
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }
}
