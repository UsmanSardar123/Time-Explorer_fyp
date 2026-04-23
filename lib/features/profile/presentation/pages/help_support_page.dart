import 'package:flutter/material.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = theme.brightness == Brightness.dark ? const Color(0xFF1E293B) : Colors.white;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          _buildSupportHeader(),
          const SizedBox(height: 32),
          _buildSupportOption(
            cardColor: cardColor,
            icon: Icons.help_outline_rounded,
            title: 'Help Center',
            subtitle: 'Read articles and tutorials',
            color: Colors.blue,
          ),
          const SizedBox(height: 16),
          _buildSupportOption(
            cardColor: cardColor,
            icon: Icons.support_agent_rounded,
            title: 'Contact Support',
            subtitle: 'Chat with our support team',
            color: Colors.green,
          ),
          const SizedBox(height: 16),
          _buildSupportOption(
            cardColor: cardColor,
            icon: Icons.question_answer_outlined,
            title: 'FAQ',
            subtitle: 'Frequently asked questions',
            color: Colors.orange,
          ),
          const SizedBox(height: 16),
          _buildSupportOption(
            cardColor: cardColor,
            icon: Icons.feedback_outlined,
            title: 'Send Feedback',
            subtitle: 'Tell us how to improve',
            color: Colors.purple,
          ),
        ],
      ),
    );
  }

  Widget _buildSupportHeader() {
    return Column(
      children: [
        const Icon(Icons.headset_mic_outlined, size: 80, color: Colors.blue),
        const SizedBox(height: 16),
        const Text(
          'How can we help you?',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Our team is here to assist you with any questions or issues.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildSupportOption({
    required Color cardColor,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: () {},
      ),
    );
  }
}
