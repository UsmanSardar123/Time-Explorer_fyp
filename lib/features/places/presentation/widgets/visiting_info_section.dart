import 'package:flutter/material.dart';

class VisitingInfoSection extends StatelessWidget {
  final String? openingHours;
  final String? ticketPrice;
  final String? bestTimeToVisit;
  final String? visitDuration;

  const VisitingInfoSection({
    super.key,
    this.openingHours,
    this.ticketPrice,
    this.bestTimeToVisit,
    this.visitDuration,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Visiting Information',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F4FF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                _buildInfoRow(Icons.schedule, 'Opening Hours', openingHours ?? 'Not specified'),
                const Divider(height: 30),
                _buildInfoRow(Icons.confirmation_number_outlined, 'Ticket Price', ticketPrice ?? 'Free / Varies'),
                const Divider(height: 30),
                _buildInfoRow(Icons.calendar_today, 'Best Time', bestTimeToVisit ?? 'All year round'),
                const Divider(height: 30),
                _buildInfoRow(Icons.timer_outlined, 'Estimated Visit', visitDuration ?? '1-2 hours'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.blueAccent[700], size: 24),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
