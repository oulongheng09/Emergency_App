import 'package:flutter/material.dart';
import '../../core/services/backend_api_service.dart';
import '../../models/backend_user.dart';
import '../../state/app_settings_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/primary_button.dart';

class ProfileScreen extends StatefulWidget {
  final BackendUser? user;
  final String? token;
  final ValueChanged<BackendUser>? onSaved;
  final VoidCallback? onLogout;

  const ProfileScreen({
    super.key,
    this.user,
    this.token,
    this.onSaved,
    this.onLogout,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _fullNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _locationController = TextEditingController();
  final _bloodGroupController = TextEditingController();
  final _allergiesController = TextEditingController();
  final _medicalNotesController = TextEditingController();

  bool _isLoading = true;
  bool _isSaving = false;
  String _selectedLanguage = 'EN';
  String? _errorMessage;
  BackendUser? _currentUser;

  @override
  void initState() {
    super.initState();
    _applyUser(widget.user);
    _loadUser();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneNumberController.dispose();
    _locationController.dispose();
    _bloodGroupController.dispose();
    _allergiesController.dispose();
    _medicalNotesController.dispose();
    super.dispose();
  }

  Future<void> _loadUser() async {
    if (widget.token == null) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      final remoteUser = await BackendApiService.instance.fetchCurrentUser(
        widget.token!,
      );
      if (remoteUser != null) {
        _applyUser(remoteUser);
      }
    } catch (error) {
      _errorMessage = error.toString();
      _showMessage(_errorMessage ?? 'Failed to load user.', error: true);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _applyUser(BackendUser? user) {
    if (user == null) {
      return;
    }
    _currentUser = user;
    _fullNameController.text = user.fullName;
    _phoneNumberController.text = user.phoneNumber ?? '';
    _locationController.text = user.location ?? user.address ?? '';
    _bloodGroupController.text = user.bloodGroup ?? '';
    _allergiesController.text = user.allergies ?? '';
    _medicalNotesController.text = user.urgentMedicalNotes ?? '';
  }

  Future<void> _saveProfile() async {
    final currentUser = _currentUser ?? widget.user;
    final token = widget.token;

    if (currentUser == null || token == null) {
      _showMessage('No authenticated user is available.');
      return;
    }

    final fullName = _fullNameController.text.trim();
    if (fullName.isEmpty) {
      _showMessage('Full name is required.');
      return;
    }

    final payload = <String, dynamic>{
      'full_name': fullName,
      'blood_group': _bloodGroupController.text.trim().isEmpty
          ? null
          : _bloodGroupController.text.trim(),
      'allergies': _allergiesController.text.trim().isEmpty
          ? null
          : _allergiesController.text.trim(),
      'location': _locationController.text.trim().isEmpty
          ? null
          : _locationController.text.trim(),
      'urgent_medical_notes': _medicalNotesController.text.trim().isEmpty
          ? null
          : _medicalNotesController.text.trim(),
    };

    final phoneDigits = _phoneNumberController.text.replaceAll(
      RegExp(r'[^0-9]'),
      '',
    );
    if (phoneDigits.isNotEmpty) {
      payload['phone_number'] = int.parse(phoneDigits);
    }

    setState(() => _isSaving = true);

    try {
      final updatedUser = await BackendApiService.instance.updateUser(
        token: token,
        userId: currentUser.id,
        payload: payload,
      );
      _applyUser(updatedUser);
      widget.onSaved?.call(updatedUser);
      _showMessage('Profile saved successfully.');
    } catch (error) {
      _showMessage(error.toString(), error: true);
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _showMessage(String message, {bool error = false}) {
    if (!mounted) return;
    final snack = SnackBar(
      content: Text(message),
      backgroundColor: error ? Colors.red.shade700 : AppColors.primaryRed,
      action: SnackBarAction(
        label: 'Dismiss',
        textColor: Colors.white,
        onPressed: () {},
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snack);
  }

  Future<void> _confirmLogout() async {
    if (!mounted) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      widget.onLogout?.call();
      if (mounted) {
        _showMessage('Logged out.');
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final settings = AppSettingsScope.of(context);
    final isDarkMode = settings.isDarkMode;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Profile'),
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(14, 8, 14, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _ProfileHeader(),
                    if (_errorMessage != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ],
                    const SizedBox(height: 16),
                    const Text('SETTINGS', style: AppTextStyles.sectionTitle),
                    const SizedBox(height: 7),
                    _SectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Language', style: AppTextStyles.label),
                          const SizedBox(height: 9),
                          Row(
                            children: [
                              Expanded(
                                child: _LanguagePill(
                                  label: 'EN',
                                  selected: _selectedLanguage == 'EN',
                                  onTap: () {
                                    setState(() {
                                      _selectedLanguage = 'EN';
                                    });
                                  },
                                ),
                              ),
                              Expanded(
                                child: _LanguagePill(
                                  label: 'KH',
                                  selected: _selectedLanguage == 'KH',
                                  onTap: () {
                                    setState(() {
                                      _selectedLanguage = 'KH';
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 9),
                    _SectionCard(
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Appearance\n${isDarkMode ? 'Dark Mode' : 'Light Mode'}',
                              style: theme.textTheme.labelLarge?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ),
                          Switch(
                            value: isDarkMode,
                            activeThumbColor: colorScheme.primary,
                            onChanged: settings.setDarkMode,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    _SectionCard(
                      title: 'PROFILE INFORMATION',
                      icon: Icons.person_outline,
                      child: Column(
                        children: [
                          _EditableField(
                            controller: _fullNameController,
                            label: 'Full Name',
                          ),
                          const SizedBox(height: 12),
                          _EditableField(
                            controller: _phoneNumberController,
                            label: 'Phone Number',
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(height: 12),
                          _EditableField(
                            controller: _locationController,
                            label: 'Location',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    _SectionCard(
                      title: 'MEDICAL PROFILE',
                      icon: Icons.medical_services_outlined,
                      child: Column(
                        children: [
                          _EditableField(
                            controller: _bloodGroupController,
                            label: 'Blood Group',
                          ),
                          const SizedBox(height: 12),
                          _EditableField(
                            controller: _allergiesController,
                            label: 'Known Allergies',
                          ),
                          const SizedBox(height: 12),
                          _EditableField(
                            controller: _medicalNotesController,
                            label: 'Urgent Medical Notes',
                            maxLines: 3,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    PrimaryButton(
                      text: _isSaving ? 'SAVING...' : 'SAVE PROFILE',
                      onPressed: _isSaving ? null : _saveProfile,
                    ),
                    const SizedBox(height: 12),
                    PrimaryButton(
                      text: 'LOGOUT',
                      icon: Icons.logout,
                      onPressed: _confirmLogout,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Icon(Icons.location_on, color: AppColors.primaryRed, size: 16),
        SizedBox(width: 4),
        Text('KhmerSOS', style: AppTextStyles.appTitle),
        Spacer(),
        Icon(Icons.settings_outlined, size: 18, color: AppColors.primaryRed),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String? title;
  final IconData? icon;
  final Widget child;

  const _SectionCard({required this.child, this.title, this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDarkMode
            ? theme.colorScheme.surface
            : AppColors.lightRed.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.65)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Row(
              children: [
                if (icon != null)
                  Icon(icon, size: 14, color: AppColors.primaryRed),
                if (icon != null) const SizedBox(width: 5),
                Text(title!, style: AppTextStyles.sectionTitle),
              ],
            ),
            const SizedBox(height: 12),
          ],
          child,
        ],
      ),
    );
  }
}

class _EditableField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final int? maxLines;
  final TextInputType keyboardType;

  const _EditableField({
    required this.controller,
    required this.label,
    this.maxLines,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: TextStyle(color: theme.colorScheme.onSurface),
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: isDarkMode
                ? theme.colorScheme.surface.withValues(alpha: 0.78)
                : AppColors.card,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(color: theme.dividerColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: AppColors.primaryRed),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),
          ),
        ),
      ],
    );
  }
}

class _LanguagePill extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _LanguagePill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      child: Container(
        height: 34,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primaryRed
              : isDarkMode
              ? theme.colorScheme.surface.withValues(alpha: 0.86)
              : const Color(0xFFEFEFEF),
          border: Border.all(color: theme.dividerColor),
          borderRadius: BorderRadius.horizontal(
            left: label == 'EN' ? const Radius.circular(7) : Radius.zero,
            right: label == 'KH' ? const Radius.circular(7) : Radius.zero,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected
                ? Colors.white
                : isDarkMode
                ? Colors.white70
                : AppColors.textDark,
            fontWeight: FontWeight.w800,
            fontSize: 11,
          ),
        ),
      ),
    );
  }
}
