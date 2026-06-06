import 'package:flutter/material.dart';
import '../../domain/entities/people_entities.dart';

class ContactCardWidget extends StatelessWidget {
  final PeopleContactEntity contact;
  final VoidCallback onTap;

  const ContactCardWidget({
    super.key,
    required this.contact,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white10,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: Colors.blueAccent.withValues(alpha: 0.2),
          child: Text(
            contact.firstName.isNotEmpty ? contact.firstName[0].toUpperCase() : '?',
            style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          '${contact.firstName} ${contact.lastName}',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(contact.email, style: const TextStyle(color: Colors.white70)),
            if (contact.company != null)
              Text(contact.company!, style: const TextStyle(color: Colors.white54)),
          ],
        ),
        trailing: _buildTypeChip(contact.status),
      ),
    );
  }

  Widget _buildTypeChip(String type) {
    Color color;
    switch (type.toLowerCase()) {
      case 'lead':
        color = Colors.orangeAccent;
        break;
      case 'customer':
        color = Colors.greenAccent;
        break;
      case 'partner':
        color = Colors.purpleAccent;
        break;
      default:
        color = Colors.grey;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        type.toUpperCase(),
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }
}
