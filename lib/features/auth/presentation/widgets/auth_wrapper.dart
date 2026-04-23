import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeexplorer/features/auth/presentation/pages/login_page.dart';
import 'package:timeexplorer/features/auth/presentation/providers/auth_provider.dart';
import 'package:timeexplorer/features/home/presentation/pages/home_page.dart';
import 'package:timeexplorer/features/admin/presentation/pages/admin_dashboard_page.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    // Show loading indicator while checking authentication
    if (authProvider.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // If authenticated
    if (authProvider.isAuthenticated) {
      // Admin user
      if (authProvider.isAdmin) {
        return const AdminDashboardPage();
      }

      return const HomePage();
    }

    // If not authenticated, show login page
    return const LoginPage();
  }
}