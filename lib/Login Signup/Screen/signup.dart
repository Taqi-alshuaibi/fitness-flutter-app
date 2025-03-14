import 'package:flutter/material.dart';
import 'package:flutter_application_4/Login%20Signup/Widget/button.dart';
import '../Services/authentication.dart';
import '../Widget/snackbar.dart';
import '../Widget/text_field.dart';
import 'home_screen.dart';
import 'login.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _signupUser() async {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      showSnackBar(context, 'الرجى');
      return;
    }

    setState(() => _isLoading = true);
    String res = await AuthMethod().signupUser(
      email: _emailController.text,
      password: _passwordController.text,
      name: _nameController.text,
    );

    if (res == "success") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      showSnackBar(context, res);
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F3443), Color(0xFF34A694)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: size.height * 0.05),
                  const Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Container for Name, Email, Password, and Sign Up Button
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Name Field
                        TextFieldInput(
                          icon: Icons.person_outline,
                          textEditingController: _nameController,
                          hintText: 'Full Name',
                          textInputType: TextInputType.name,
                          iconColor: Colors.white70,
                        ),
                        const SizedBox(height: 15),
                        // Email Field
                        TextFieldInput(
                          icon: Icons.email_outlined,
                          textEditingController: _emailController,
                          hintText: 'Email Address',
                          textInputType: TextInputType.emailAddress,
                          iconColor: Colors.white70,
                        ),
                        const SizedBox(height: 15),
                        // Password Field
                        TextFieldInput(
                          icon: Icons.lock_outline,
                          textEditingController: _passwordController,
                          hintText: 'Password',
                          textInputType: TextInputType.visiblePassword,
                          isPass: true,
                          iconColor: Colors.white70,
                        ),
                        const SizedBox(height: 20),
                        // Sign Up Button
                        MyButtons(
                          onTap: _signupUser,
                          text: "Sign Up",
                          isLoading: _isLoading,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF34A694), Color(0xFF0F3443)],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account? ",
                        style: TextStyle(color: Colors.white70),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                        ),
                        child: const Text(
                          "Login Now",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Add the fitness icon and text at the bottom
                  SizedBox(height: size.height * 0.1),
                  const Icon(Icons.fitness_center, size: 100, color: Colors.white),
                  const SizedBox(height: 20),
                  const Text(
                    'Start your fitness journey today!',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}