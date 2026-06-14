import 'package:flutter/material.dart';

import 'features/auth/login_screen.dart';
import 'features/first_aid/first_aid_list_screen.dart';
import 'features/home/home_screen.dart';
import 'features/map/map_screen.dart';
import 'features/personal_contacts/personal_contacts_screen.dart';
import 'features/splash/splash_screen.dart';

import 'models/backend_session.dart';
import 'models/backend_user.dart';

import 'state/app_settings_provider.dart';
import 'theme/app_colors.dart';
import 'theme/app_theme.dart';

class EmergencyApp extends StatefulWidget {
  const EmergencyApp({super.key});

  @override
  State<EmergencyApp> createState() => _EmergencyAppState();
}

class _EmergencyAppState extends State<EmergencyApp> {
  int _screen = 0;
  int _tab = 0;

  BackendSession? _session;

  late final AppSettingsController _settingsController;

  @override
  void initState() {
    super.initState();
    _settingsController = AppSettingsController();
  }

  @override
  void dispose() {
    _settingsController.dispose();
    super.dispose();
  }

  void _handleAuthenticated(BackendSession session) {
    setState(() {
      _session = session;
      _screen = 2;
      _tab = 0;
    });
  }

  void _handleUserUpdated(BackendUser user) {
    setState(() {
      if (_session != null) {
        _session = _session!.copyWith(user: user);
      }
    });
  }

  void _handleLogout() {
    setState(() {
      _session = null;
      _screen = 1;
      _tab = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppSettingsScope(
      controller: _settingsController,
      child: AnimatedBuilder(
        animation: _settingsController,
        builder: (context, _) {
          final isDarkMode = _settingsController.isDarkMode;

          final activeSurface = isDarkMode
              ? const Color(0xFF181C22)
              : AppColors.card;

          final activePrimary = isDarkMode
              ? const Color(0xFFFF6B7D)
              : AppColors.primaryRed;

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'KhmerSOS',

            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: _settingsController.themeMode,

            home: _screen == 0
                ? SplashScreen(
                    onFinish: () {
                      setState(() => _screen = 1);
                    },
                  )
                : _screen == 1
                    ? LoginScreen(
                        onAuthenticated: _handleAuthenticated,
                      )
                    : Scaffold(
                        body: IndexedStack(
                          index: _tab,
                          children: [
                            HomeScreen(
                              user: _session?.user,
                              token: _session?.token,
                              onUserUpdated: _handleUserUpdated,
                              onLogout: _handleLogout,
                            ),

                            const MapScreen(),

                            FirstAidListScreen(
                              user: _session?.user,
                              token: _session?.token,
                              onUserUpdated: _handleUserUpdated,
                              onLogout: _handleLogout,
                            ),

                            PersonalContactsScreen(
                              user: _session?.user,
                              token: _session?.token,
                              onUserUpdated: _handleUserUpdated,
                              onLogout: _handleLogout,
                            ),
                          ],
                        ),

                        bottomNavigationBar: BottomNavigationBar(
                          currentIndex: _tab,

                          onTap: (index) {
                            setState(() => _tab = index);
                          },

                          backgroundColor: activeSurface,

                          selectedItemColor: activePrimary,

                          unselectedItemColor: isDarkMode
                              ? Colors.white60
                              : AppColors.textDark,

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
                              icon: Icon(
                                Icons.medical_information,
                                size: 20,
                              ),
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
        },
      ),
    );
  }
}