import 'package:flutter/material.dart';

class ErasPreferencePage extends StatefulWidget {
  const ErasPreferencePage({super.key});

  @override
  State<ErasPreferencePage> createState() => _ErasPreferencePageState();
}

class _ErasPreferencePageState extends State<ErasPreferencePage> {
  final List<String> _eras = [
    'All Eras',
    'Ancient Civilizations',
    'Middle Ages',
    'Renaissance',
    'Victorian Era',
    'World Wars',
    'Information Age',
  ];
  
  String _selectedEra = 'All Eras';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = theme.brightness == Brightness.dark ? const Color(0xFF1E293B) : Colors.white;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Era Preferences'),
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(24.0),
        itemCount: _eras.length,
        itemBuilder: (context, index) {
          final era = _eras[index];
          final isSelected = era == _selectedEra;
          
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? Colors.indigo.shade500 : Colors.transparent,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
              ],
            ),
            child: ListTile(
              title: Text(era, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
              trailing: isSelected ? Icon(Icons.check_circle, color: Colors.indigo.shade500) : null,
              onTap: () {
                setState(() => _selectedEra = era);
                // In a real app, we would update this in the backend/provider
              },
            ),
          );
        },
      ),
    );
  }
}
