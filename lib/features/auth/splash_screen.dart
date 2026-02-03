import 'package:flutter/material.dart';
import 'package:api/api.dart';
import 'package:ui/ui.dart';
import '../main_shell.dart';
import 'login_screen.dart';

/// Splash screen shown on app start
/// Checks for stored auth tokens and navigates accordingly
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    // Allow splash animation to show briefly
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      // Initialize auth state from storage
      await ApiClient.init();

      final authState = AuthState();

      if (authState.isLoggedIn) {
        // User has valid stored tokens → go to main app
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const MainShell()),
          );
        }
      } else {
        // No stored tokens → go to login
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        }
      }
    } catch (e) {
      print('Auth check failed: $e');
      // On any error, go to login
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            SizedBox(
              height: 100,
              child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
            ),
            const SizedBox(height: 32),

            // App title
            Text(
              'THESIS DEFENSE',
              style: AppTextStyles.h2.copyWith(
                color: AppColors.primary,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Lecturer Scheduling System',
              style: AppTextStyles.bodyMedium,
            ),

            const SizedBox(height: 48),

            // Loading indicator
            const CircularProgressIndicator(
              color: AppColors.primary,
              strokeWidth: 2,
            ),
          ],
        ),
      ),
    );
  }
}
