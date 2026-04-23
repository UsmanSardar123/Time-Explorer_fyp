import 'package:flutter/material.dart';

class PolicyPage extends StatelessWidget {
  final String title;
  const PolicyPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Last Updated: March 2026',
              style: TextStyle(color: Colors.grey.shade600, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 24),
            Text(
              'Welcome to Time Explorer. Your $title is important to us.',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 16),
            const Text(
              'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 16),
            const Text(
              '1. Information Collection\n2. Use of Data\n3. Data Protection\n4. Your Rights\n5. Changes to this Policy',
              style: TextStyle(fontSize: 16, height: 1.8),
            ),
          ],
        ),
      ),
    );
  }
}
