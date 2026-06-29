import 'package:flutter/material.dart';

import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../layout/main_layout_page.dart';
import '../controller/auth_controller.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthController authController = AuthController();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  bool showPassword = false;

  Future<void> login() async {
    final success = await authController.login(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),

      
    );

    if (!mounted) return;

    if (success) {
      Navigator.pushReplacement(
        context,

        MaterialPageRoute(builder: (_) => const MainLayoutPage()),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Login Failed")));
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF2F2F2),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),

          child: Container(
            constraints: const BoxConstraints(maxWidth: 450),

            padding: const EdgeInsets.all(30),

            decoration: BoxDecoration(
              color: Colors.white,

              borderRadius: BorderRadius.circular(20),

              boxShadow: const [
                BoxShadow(blurRadius: 20, color: Colors.black12),
              ],
            ),

            child: Column(
              children: [
                const Text(
                  "Welcome Back",

                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff1F5FA3),
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  "Sign in to your account",
                  style: TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 30),

                CustomTextField(
                  controller: emailController,
                  hintText: "Email Address",
                ),

                const SizedBox(height: 20),

                CustomTextField(
                  controller: passwordController,
                  hintText: "Password",
                  obscureText: !showPassword,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                    icon: Icon(
                      showPassword ? Icons.visibility_off : Icons.visibility,
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                Align(
                  alignment: Alignment.centerRight,

                  child: TextButton(
                    onPressed: () {},

                    child: const Text("Forgot Password?"),
                  ),
                ),

                const SizedBox(height: 10),

                CustomButton(
                  title: "Login",

                  isLoading: authController.isLoading,

                  onTap: login,
                ),

                const SizedBox(height: 25),

                Row(
                  children: const [
                    Expanded(child: Divider()),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text("OR"),
                    ),

                    Expanded(child: Divider()),
                  ],
                ),

                const SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,

                  height: 50,

                  child: OutlinedButton(
                    onPressed: () {},

                    child: const Text("Continue with Google"),
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    const Text("Don't have an account?"),

                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,

                          MaterialPageRoute(
                            builder: (_) => const RegisterPage(),
                          ),
                        );
                      },

                      child: const Text("Register"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
