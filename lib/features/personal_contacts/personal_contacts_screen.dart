import 'package:emergency_front_end/features/personal_contacts/add_edit_contact_screen.dart';
import 'package:emergency_front_end/features/profile/profile_screen.dart';
import 'package:emergency_front_end/core/services/backend_api_service.dart';
import 'package:emergency_front_end/models/backend_user.dart';
import 'package:emergency_front_end/models/personal_contact_model.dart';
import 'package:emergency_front_end/theme/app_colors.dart';
import 'package:emergency_front_end/l10n/app_text.dart';
import 'package:flutter/material.dart';

class PersonalContactsScreen extends StatefulWidget {
  final BackendUser? user;
  final String? token;
  final ValueChanged<BackendUser>? onUserUpdated;
  final VoidCallback? onLogout;

  const PersonalContactsScreen({
    super.key,
    this.user,
    this.token,
    this.onUserUpdated,
    this.onLogout,
  });

  @override
  State<PersonalContactsScreen> createState() => _PersonalContactsScreenState();
}

class _PersonalContactsScreenState extends State<PersonalContactsScreen> {
  final BackendApiService _service = BackendApiService.instance;

  List<PersonalContactModel> _contacts = [];

  bool _isLoading = true;
  IconData _getIcon(String relationship) {
    switch (relationship.toLowerCase()) {
      case 'family':
        return Icons.person_rounded;

      case 'loved one':
        return Icons.favorite_rounded;

      case 'doctor':
        return Icons.medical_services_rounded;

      case 'work':
        return Icons.work_rounded;

      default:
        return Icons.person_rounded;
    }
  }

  Color _getIconColor(String relationship) {
    switch (relationship.toLowerCase()) {
      case 'family':
        return const Color.fromARGB(255, 26, 245, 77);

      case 'doctor':
        return const Color.fromARGB(255, 248, 16, 16);

      case 'loved one':
        return const Color.fromARGB(255, 252, 52, 162);

      case 'work':
        return AppColors.policeBlue;

      default:
        return AppColors.policeBlue;
    }
  }

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    if (widget.user == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    if (widget.user!.id.isEmpty) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      final data = await _service.getEmergencyContacts(widget.user!.id);

      setState(() {
        _contacts = data.map<PersonalContactModel>((e) {
          final relationship = e['relationship'] ?? '';

          return PersonalContactModel(
            id: e['id'].toString(),
            name: e['name'] ?? '',
            relationship: relationship,
            phone: e['phone_number'].toString(),
            icon: _getIcon(relationship),
            iconColor: _getIconColor(relationship),
          );
        }).toList();

        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _openAddContact() async {
    final result = await Navigator.of(context).push<PersonalContactModel>(
      MaterialPageRoute(builder: (_) => const AddEditContactScreen()),
    );

    if (result == null || widget.user == null) {
      return;
    }

    try {
      await _service.createEmergencyContact(
        userId: widget.user!.id,
        name: result.name,
        relationship: result.relationship,
        phone: result.phone.replaceAll(RegExp(r'[^0-9]'), ''),
      );

      await _loadContacts();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppText.t(
                context,
                en: 'Contact added successfully',
                km: 'បានបន្ថែមទំនាក់ទំនងជោគជ័យ',
              ),
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add contact: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _openEditContact(PersonalContactModel contact) async {
    final result = await Navigator.of(context).push<PersonalContactModel>(
      MaterialPageRoute(builder: (_) => AddEditContactScreen(contact: contact)),
    );

    if (result == null) {
      return;
    }

    try {
      await _service.updateEmergencyContact(
        id: contact.id,
        name: result.name,
        relationship: result.relationship,
        phone: result.phone.replaceAll(RegExp(r'[^0-9]'), ''),
      );

      await _loadContacts();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppText.t(
                context,
                en: 'Contact updated successfully',
                km: 'បានអាប់ដេតទំនាក់ទំនងជោគជ័យ',
              ),
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update contact: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _deleteContact(PersonalContactModel contact) async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            AppText.t(context, en: 'Delete Contact', km: 'លុបទំនាក់ទំនង'),
          ),
          content: Text(
            AppText.t(
              context,
              en: 'Are you sure you want to delete ${contact.name}?',
              km: 'តើអ្នកពិតជាចង់លុប ${contact.name} មែនទេ?',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(AppText.t(context, en: 'Cancel', km: 'បោះបង់')),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(
                AppText.t(context, en: 'Delete', km: 'លុប'),
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    try {
      await _service.deleteEmergencyContact(contact.id);

      await _loadContacts();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppText.t(
                context,
                en: 'Contact deleted successfully',
                km: 'បានលុបទំនាក់ទំនងជោគជ័យ',
              ),
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppText.t(
                context,
                en: 'Failed to delete contact: $e',
                km: 'លុបទំនាក់ទំនងបរាជ័យ: $e',
              ),
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(8, 6, 8, 20),
          children: [
            _ContactsHeader(
              user: widget.user,
              token: widget.token,
              onUserUpdated: widget.onUserUpdated,
              onLogout: widget.onLogout,
            ),
            const SizedBox(height: 6),
            Text(
              AppText.t(
                context,
                en: 'My Emergency Contacts',
                km: 'ទំនាក់ទំនងបន្ទាន់របស់ខ្ញុំ',
              ),
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w900,
                color: theme.colorScheme.onSurface,
                height: 0.95,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              AppText.t(
                context,
                en: 'These individuals will be notified instantly when you trigger an SOS alert.',
                km: 'មនុស្សទាំងនេះនឹងទទួលបានការជូនដំណឹងភ្លាមៗពេលអ្នកបើក SOS។',
              ),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isDarkMode ? Colors.white70 : AppColors.textGrey,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 44,
              child: ElevatedButton.icon(
                onPressed: _openAddContact,
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: AppColors.primaryRed,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.add_rounded, size: 18),
                label: Text(
                  AppText.t(context, en: 'ADD CONTACT', km: 'បន្ថែមទំនាក់ទំនង'),
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
            ),
            const SizedBox(height: 16),
            for (final contact in _contacts) ...[
              _EmergencyContactCard(
                data: contact,
                onEdit: () => _openEditContact(contact),
                onDelete: () => _deleteContact(contact),
              ),
              const SizedBox(height: 12),
            ],
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? const Color(0xFF1B2532)
                    : const Color(0xFFEAF4FF),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isDarkMode
                      ? const Color(0xFF304154)
                      : const Color(0xFFD5E6FF),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        size: 15,
                        color: AppColors.policeBlue,
                      ),
                      SizedBox(width: 6),
                      Text(
                        AppText.t(context, en: 'Setup Tip', km: 'ដំណឹងត្រៀម'),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          color: AppColors.policeBlue,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    AppText.t(
                      context,
                      en: 'We recommend having at least 3 active emergency contacts for redundancy in critical situations.',
                      km: 'យើងស្នើឲ្យមានយ៉ាងហោចណាស់ 3 ទំនាក់ទំនងបន្ទាន់សកម្ម ដើម្បីមានការបម្រុងក្នុងស្ថានការណ៍សំខាន់ៗ។',
                    ),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: isDarkMode ? Colors.white70 : AppColors.textGrey,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Container(
              height: 130,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [Color(0xFF3A3A3A), Color(0xFF141414)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: 18,
                    top: 18,
                    child: _PreviewTile(
                      icon: Icons.add_box_outlined,
                      label: AppText.t(
                        context,
                        en: 'Contacts',
                        km: 'ទំនាក់ទំនង',
                      ),
                    ),
                  ),
                  Positioned(
                    right: 18,
                    top: 18,
                    child: _PreviewTile(
                      icon: Icons.shield_outlined,
                      label: AppText.t(
                        context,
                        en: 'SOS Alerts',
                        km: 'ការជូនដំណឹង SOS',
                      ),
                    ),
                  ),
                  Positioned(
                    left: 18,
                    bottom: 18,
                    child: _PreviewTile(
                      icon: Icons.wallet_outlined,
                      label: AppText.t(
                        context,
                        en: 'Medical ID',
                        km: 'អត្តសញ្ញាណវេជ្ជសាស្ត្រ',
                      ),
                    ),
                  ),
                  const Center(
                    child: Icon(
                      Icons.phone_in_talk_rounded,
                      color: Colors.white24,
                      size: 56,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactsHeader extends StatelessWidget {
  final BackendUser? user;
  final String? token;
  final ValueChanged<BackendUser>? onUserUpdated;
  final VoidCallback? onLogout;

  const _ContactsHeader({
    this.user,
    this.token,
    this.onUserUpdated,
    this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        const Icon(
          Icons.location_on_outlined,
          size: 15,
          color: AppColors.primaryRed,
        ),
        const SizedBox(width: 4),
        const Text(
          'KhmerSOS',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: AppColors.primaryRed,
          ),
        ),
        const Spacer(),
        IconButton(
          icon: Icon(
            Icons.settings_outlined,
            size: 18,
            color: theme.colorScheme.onSurface,
          ),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ProfileScreen(
                  user: user,
                  token: token,
                  onSaved: onUserUpdated,
                  onLogout: onLogout,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _EmergencyContactCard extends StatelessWidget {
  const _EmergencyContactCard({
    required this.data,
    required this.onEdit,
    required this.onDelete,
  });

  final PersonalContactModel data;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.75)),
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: data.iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(data.icon, size: 16, color: data.iconColor),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.name,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    color: theme.colorScheme.onSurface,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  data.relationship,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color:
                        theme.textTheme.bodySmall?.color?.withValues(
                          alpha: 0.7,
                        ) ??
                        AppColors.textGrey,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  data.phone,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          _ContactIconButton(
            icon: Icons.edit_outlined,
            color: const Color.fromARGB(255, 0, 170, 255),
            onTap: onEdit,
          ),

          const SizedBox(width: 8),

          _ContactIconButton(
            icon: Icons.delete_outline_rounded,
            color: Color(0xFFF06B6B),
            onTap: onDelete,
          ),
        ],
      ),
    );
  }
}

class _ContactIconButton extends StatelessWidget {
  const _ContactIconButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: theme.dividerColor.withValues(alpha: 0.75)),
        ),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }
}

class _PreviewTile extends StatelessWidget {
  const _PreviewTile({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 76,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 14, color: Colors.white70),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.w700,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
