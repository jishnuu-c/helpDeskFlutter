import 'package:flutter/material.dart';

import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../controllers/auth_controller.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() =>
      _RegisterPageState();
}

class _RegisterPageState
    extends State<RegisterPage> {

  final AuthController authController =
      AuthController();

  final fullNameController =
      TextEditingController();

  final emailController =
      TextEditingController();

  final phoneController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  final confirmPasswordController =
      TextEditingController();

  bool showPassword = false;
  bool showConfirmPassword = false;

  Future<void> register() async {

    if (fullNameController.text.isEmpty ||
        emailController.text.isEmpty ||
        phoneController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text
            .isEmpty) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Please fill all fields",
          ),
        ),
      );
      return;
    }

    if (passwordController.text !=
        confirmPasswordController.text) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Passwords do not match",
          ),
        ),
      );
      return;
    }

    final success =
        await authController.register(

      fullName:
          fullNameController.text.trim(),

      email:
          emailController.text.trim(),

      phone:
          phoneController.text.trim(),

      password:
          passwordController.text.trim(),
    );

    if (!mounted) return;

    if (success) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Registration Successful",
          ),
        ),
      );

      Navigator.pop(context);

    } else {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Registration Failed",
          ),
        ),
      );
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(0xffF2F2F2),

      body: Center(

        child: SingleChildScrollView(

          padding:
              const EdgeInsets.all(24),

          child: Container(

            constraints:
                const BoxConstraints(
              maxWidth: 550,
            ),

            padding:
                const EdgeInsets.all(30),

            decoration: BoxDecoration(

              color: Colors.white,

              borderRadius:
                  BorderRadius.circular(
                20,
              ),

              boxShadow: const [

                BoxShadow(
                  blurRadius: 20,
                  color:
                      Colors.black12,
                )
              ],
            ),

            child: Column(

              children: [

                const Text(

                  "Create Account",

                  style: TextStyle(
                    fontSize: 30,
                    fontWeight:
                        FontWeight.bold,
                    color:
                        Color(0xff1F5FA3),
                  ),
                ),

                const SizedBox(
                  height: 8,
                ),

                const Text(
                  "Register to get started",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(
                  height: 30,
                ),

                CustomTextField(
                  controller:
                      fullNameController,
                  hintText:
                      "Full Name",
                ),

                const SizedBox(
                  height: 16,
                ),

                CustomTextField(
                  controller:
                      emailController,
                  hintText:
                      "Email Address",
                ),

                const SizedBox(
                  height: 16,
                ),

                CustomTextField(
                  controller:
                      phoneController,
                  hintText:
                      "Phone Number",
                  keyboardType:
                      TextInputType.phone,
                ),

                const SizedBox(
                  height: 16,
                ),

                CustomTextField(
                  controller:
                      passwordController,
                  hintText:
                      "Password",
                  obscureText:
                      !showPassword,
                  suffixIcon:
                      IconButton(
                    onPressed: () {

                      setState(() {

                        showPassword =
                            !showPassword;
                      });
                    },
                    icon: Icon(
                      showPassword
                          ? Icons
                              .visibility_off
                          : Icons
                              .visibility,
                    ),
                  ),
                ),

                const SizedBox(
                  height: 16,
                ),

                CustomTextField(
                  controller:
                      confirmPasswordController,
                  hintText:
                      "Confirm Password",
                  obscureText:
                      !showConfirmPassword,
                  suffixIcon:
                      IconButton(
                    onPressed: () {

                      setState(() {

                        showConfirmPassword =
                            !showConfirmPassword;
                      });
                    },
                    icon: Icon(
                      showConfirmPassword
                          ? Icons
                              .visibility_off
                          : Icons
                              .visibility,
                    ),
                  ),
                ),

                const SizedBox(
                  height: 25,
                ),

                CustomButton(

                  title:
                      "Create Account",

                  isLoading:
                      authController
                          .isLoading,

                  onTap: register,
                ),

                const SizedBox(
                  height: 25,
                ),

                Row(
                  children: const [

                    Expanded(
                      child: Divider(),
                    ),

                    Padding(
                      padding:
                          EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      child: Text(
                        "OR",
                      ),
                    ),

                    Expanded(
                      child: Divider(),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 25,
                ),

                SizedBox(

                  width:
                      double.infinity,

                  height: 50,

                  child:
                      OutlinedButton(

                    onPressed: () {},

                    child: const Text(
                      "Continue with Google",
                    ),
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

                Row(

                  mainAxisAlignment:
                      MainAxisAlignment
                          .center,

                  children: [

                    const Text(
                      "Already have an account?",
                    ),

                    TextButton(

                      onPressed: () {
                        Navigator.pop(
                          context,
                        );
                      },

                      child: const Text(
                        "Login",
                      ),
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