import 'package:flutter/material.dart';
import 'package:personaltrainer/features/auth/viewmodels/auth_viewmodel.dart';
import 'package:provider/provider.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  bool _isLoading = false;

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
              colors: [Color(0xFF1A132F), Color(0xFF120B23)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 60),
              Expanded(
                flex: 3,
                child: Center(
                  child: Image.asset(
                    "assets/images/fitness.png",
                    height: 280,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    color: Color(0xFF1E1E2C),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Create Account 💪",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Start your fitness journey with us",
                          style: TextStyle(color: Colors.grey.shade400, fontSize: 15),
                        ),
                        const SizedBox(height: 30),
                        // Name
                        TextField(
                          controller: _nameController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFF2C2C3E),
                            labelText: "Name",
                            labelStyle: TextStyle(color: Colors.grey.shade400),
                            prefixIcon:
                                const Icon(Icons.person, color: Colors.purpleAccent),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Email
                        TextField(
                          controller: _emailController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFF2C2C3E),
                            labelText: "Email",
                            labelStyle: TextStyle(color: Colors.grey.shade400),
                            prefixIcon:
                                const Icon(Icons.email, color: Colors.purpleAccent),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Password
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFF2C2C3E),
                            labelText: "Password",
                            labelStyle: TextStyle(color: Colors.grey.shade400),
                            prefixIcon:
                                const Icon(Icons.lock, color: Colors.purpleAccent),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Confirm Password
                        TextField(
                          controller: _confirmController,
                          obscureText: true,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFF2C2C3E),
                            labelText: "Confirm Password",
                            labelStyle: TextStyle(color: Colors.grey.shade400),
                            prefixIcon:
                                const Icon(Icons.lock_outline, color: Colors.purpleAccent),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        // Sign Up Button
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF7A1CAC),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            onPressed: _isLoading
                                ? null
                                : () async {
                                    if (_passwordController.text.trim() !=
                                        _confirmController.text.trim()) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text("Passwords do not match")),
                                      );
                                      return;
                                    }
                                    setState(() => _isLoading = true);
                                    try {
                                      await auth.register(
                                        _nameController.text.trim(),
                                        _emailController.text.trim(),
                                        _passwordController.text.trim(),
                                      );
                                      if (context.mounted) Navigator.pop(context);
                                    } catch (e) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                "Registration failed: ${e.toString()}")),
                                      );
                                    } finally {
                                      if (mounted) setState(() => _isLoading = false);
                                    }
                                  },
                            child: _isLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text(
                                    "Sign Up",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                          ),
                        ),
                      ],
                    ),
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
