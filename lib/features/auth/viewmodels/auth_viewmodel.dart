import 'package:flutter/material.dart';

class AuthViewModel extends ChangeNotifier {
  String? phoneNumber;
  String? otp;

  void setPhone(String value) {
    phoneNumber = value;
    notifyListeners();
  }

  void setOtp(String value) {
    otp = value;
    notifyListeners();
  }

  Future<bool> verifyOtp() async {
    await Future.delayed(const Duration(seconds: 1));
    return otp == "1234"; // mock success for now
  }
}
