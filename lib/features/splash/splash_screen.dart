import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class SplashScreen extends StatelessWidget {
  final VoidCallback onFinish;

  const SplashScreen({super.key, required this.onFinish});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), onFinish);

    return const Scaffold(
      backgroundColor: AppColors.primaryRed,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.health_and_safety, color: Colors.white, size: 70),
            SizedBox(height: 14),
            Text(
              'KhmerSOS',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Emergency help in your hand',
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
