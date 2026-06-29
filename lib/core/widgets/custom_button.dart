import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {

  final String title;
  final VoidCallback onTap;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.title,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {

    return SizedBox(

      width: double.infinity,
      height: 55,

      child: ElevatedButton(

        onPressed: isLoading ? null : onTap,

        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff1F5FA3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),

        child: isLoading
            ? const CircularProgressIndicator(
                color: Colors.white,
              )
            : Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
      ),
    );
  }
}