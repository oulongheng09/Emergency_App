// TODO: add service list screen.
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class ServiceListScreen extends StatelessWidget {
  final String serviceName;

  const ServiceListScreen({
    super.key,
    required this.serviceName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(serviceName),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textDark,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _ServiceCard(
            name: '$serviceName Center 1',
            phone: '+855 12 345 678',
            address: 'Phnom Penh, Cambodia',
          ),
          _ServiceCard(
            name: '$serviceName Center 2',
            phone: '+855 98 765 432',
            address: 'BKK1, Phnom Penh',
          ),
        ],
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final String name;
  final String phone;
  final String address;

  const _ServiceCard({
    required this.name,
    required this.phone,
    required this.address,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: AppTextStyles.sectionTitle),
          const SizedBox(height: 8),
          Text(phone, style: AppTextStyles.body),
          const SizedBox(height: 4),
          Text(address, style: AppTextStyles.body),
        ],
      ),
    );
  }
}