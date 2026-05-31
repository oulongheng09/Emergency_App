import 'package:emergency_front_end/features/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/emergency_sos_button.dart';
import '../../widgets/quick_action_tile.dart';
import '../services/service_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const services = [
    _ServiceItem('POLICE', Icons.security, AppColors.policeBlue),
    _ServiceItem('HOSPITAL', Icons.local_hospital, AppColors.hospitalRed),
    _ServiceItem('FIRE DEPT', Icons.fire_truck, AppColors.fireOrange),
    _ServiceItem('AMBULANCE', Icons.emergency, AppColors.ambulanceRed),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(14, 8, 14, 90),
          child: Column(
            children: [
              const _LocationHeader(),
              const SizedBox(height: 58),
              EmergencySosButton(
                onLongPress: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Mock SOS activated'),
                    ),
                  );
                },
              ),
              const SizedBox(height: 48),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: services.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 1.25,
                ),
                itemBuilder: (context, index) {
                  final item = services[index];
                  return QuickActionTile(
                    title: item.title,
                    icon: item.icon,
                    iconColor: item.color,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                        builder: (_) => ServiceListScreen(serviceName: item.title),
    ),
  );
},
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class _LocationHeader extends StatelessWidget {
  const _LocationHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 23,
          padding: const EdgeInsets.symmetric(horizontal: 9),
          decoration: BoxDecoration(
            color: AppColors.primaryRed,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            children: [
              Icon(Icons.location_on, color: Colors.white, size: 12),
              SizedBox(width: 4),
              Text(
                'Phnom Penh, BKK1',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 7),
        const Text('KhmerSOS', style: AppTextStyles.appTitle),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.settings_outlined, size: 20),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const ProfileScreen(),
      ),
    );
  },
),
      ],
    );
  }
}

class _ServiceItem {
  final String title;
  final IconData icon;
  final Color color;

  const _ServiceItem(this.title, this.icon, this.color);
}