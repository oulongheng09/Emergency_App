import 'package:emergency_front_end/features/personal_contacts/personal_contacts_screen.dart';
import 'package:flutter/material.dart';
import 'features/auth/login_screen.dart';
import 'features/home/home_screen.dart';
import 'features/map/map_screen.dart';
import 'features/splash/splash_screen.dart';
import 'theme/app_colors.dart';

class EmergencyApp extends StatefulWidget {
  const EmergencyApp({super.key});

  @override
  State<EmergencyApp> createState() => _EmergencyAppState();
}

class _EmergencyAppState extends State<EmergencyApp> {
  int _screen = 0;
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KhmerSOS',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: AppColors.background,
      ),
      home: _screen == 0
          ? SplashScreen(onFinish: () => setState(() => _screen = 1))
          : _screen == 1
          ? LoginScreen(onLogin: () => setState(() => _screen = 2))
          : Scaffold(
              body: IndexedStack(
                index: _tab,
                children: const [
                  HomeScreen(),
                  MapScreen(),
                  Center(child: Text('First Aid')),
                  PersonalContactsScreen(),
                ],
              ),
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: _tab,
                onTap: (index) => setState(() => _tab = index),
                selectedItemColor: AppColors.primaryRed,
                unselectedItemColor: AppColors.textDark,
                type: BottomNavigationBarType.fixed,
                selectedFontSize: 10,
                unselectedFontSize: 10,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home, size: 20),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.map, size: 20),
                    label: 'Map',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.medical_information, size: 20),
                    label: 'First-Aid',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.contacts, size: 20),
                    label: 'Contacts',
                  ),
                ],
              ),
            ),
    );
  }
}
