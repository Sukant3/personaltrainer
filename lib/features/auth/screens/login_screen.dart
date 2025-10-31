import 'package:flutter/material.dart';
import 'package:personaltrainer/features/auth/screens/otp_screen.dart';
import 'package:personaltrainer/features/auth/viewmodels/auth_viewmodel.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();

    // Listen for phone number input changes
    _phoneController.addListener(() {
      setState(() {
        isButtonEnabled = _phoneController.text.trim().length == 10;
      });
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthViewModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0E0E12),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF1A132F),
                Color(0xFF120B23),
              ],
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 60),

              // Header Illustration
              Expanded(
                flex: 3,
                child: Center(
                  child: Image.asset(
                    "assets/images/fitness.png", // replace with your image
                    height: 300,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              // Login Card Section
              Expanded(
                flex: 4,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    color: Color(0xFF1E1E2C),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Welcome Back 👋",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Login to continue your fitness journey",
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Phone Field
                      TextField(
                        controller: _phoneController,
                        maxLength: 10,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          counterText: "", // hides counter below field
                          filled: true,
                          fillColor: const Color(0xFF2C2C3E),
                          labelText: "Phone Number",
                          labelStyle:
                              TextStyle(color: Colors.grey.shade400),
                          prefixIcon: const Icon(
                            Icons.phone,
                            color: Colors.purpleAccent,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 30),

                      // Login Button (only active when valid)
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isButtonEnabled
                                ? const Color(0xFF7A1CAC)
                                : Colors.grey.shade700,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: isButtonEnabled ? 6 : 0,
                            shadowColor: Colors.purpleAccent.withOpacity(0.4),
                          ),
                          onPressed: isButtonEnabled
                              ? () {
                                  auth.setPhone(_phoneController.text.trim());
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => const OtpScreen()),
                                  );
                                }
                              : null,
                          child: const Text(
                            "Send OTP",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),

                      // Bottom Links
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don’t have an account?",
                            style: TextStyle(color: Colors.grey.shade400),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              "Create one",
                              style: TextStyle(
                                color: Colors.purpleAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
