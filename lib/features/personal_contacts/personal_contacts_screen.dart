// TODO: add personal contacts screen.
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class PersonalContactsScreen extends StatelessWidget {
  const PersonalContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Emergency Contacts'),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textDark,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _ContactCard(
            name: 'Mother',
            phone: '+855 12 345 678',
            relationship: 'Family',
          ),
          _ContactCard(
            name: 'Brother',
            phone: '+855 98 765 432',
            relationship: 'Family',
          ),
        ],
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  final String name;
  final String phone;
  final String relationship;

  const _ContactCard({
    required this.name,
    required this.phone,
    required this.relationship,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: AppColors.lightRed,
            child: Icon(Icons.person, color: AppColors.primaryRed),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTextStyles.sectionTitle),
                Text(relationship, style: AppTextStyles.small),
                Text(phone, style: AppTextStyles.body),
              ],
            ),
          ),
          const Icon(Icons.phone, color: AppColors.primaryRed),
        ],
      ),
    );
  }
}