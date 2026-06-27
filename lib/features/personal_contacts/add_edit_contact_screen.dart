import 'package:emergency_front_end/models/personal_contact_model.dart';
import 'package:emergency_front_end/theme/app_colors.dart';
import 'package:flutter/material.dart';
import '../../l10n/app_text.dart';

class AddEditContactScreen extends StatefulWidget {
  const AddEditContactScreen({super.key, this.contact});

  final PersonalContactModel? contact;

  @override
  State<AddEditContactScreen> createState() => _AddEditContactScreenState();
}

class _AddEditContactScreenState extends State<AddEditContactScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _relationshipController;
  late final TextEditingController _phoneController;
  late _AvatarOption _selectedAvatar;

  static const List<_AvatarOption> _avatarOptions = [
    _AvatarOption(label: 'Family', icon: Icons.family_restroom_rounded),
    _AvatarOption(label: 'Loved One', icon: Icons.favorite_rounded),
    _AvatarOption(label: 'Doctor', icon: Icons.medical_services_rounded),
    _AvatarOption(label: 'Work', icon: Icons.work_rounded),
  ];

  bool get _isEditing => widget.contact != null;

  @override
  void initState() {
    super.initState();
    final contact = widget.contact;
    _nameController = TextEditingController(text: contact?.name ?? '');
    _relationshipController = TextEditingController(
      text: contact?.relationship ?? '',
    );
    _phoneController = TextEditingController(text: contact?.phone ?? '');
    _selectedAvatar = _avatarOptions.first;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _relationshipController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _saveContact() {
    final name = _nameController.text.trim();
    final relationship = _relationshipController.text.trim();
    final phone = _phoneController.text.trim();

    if (name.isEmpty || relationship.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppText.t(
              context,
              en: 'Please fill in all contact fields.',
              km: 'សូមបំពេញគ្រប់វាលទំនាក់ទំនង។',
            ),
          ),
        ),
      );
      return;
    }

    final contact = PersonalContactModel(
      id:
          widget.contact?.id ??
          DateTime.now().microsecondsSinceEpoch.toString(),
      name: name,
      relationship: relationship,
      phone: phone,
      icon: _selectedAvatar.icon,
      iconColor: Colors.blue,
    );

    Navigator.of(context).pop(contact);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        foregroundColor: theme.colorScheme.onSurface,
        elevation: 0,
        title: Text(
          _isEditing
              ? AppText.t(context, en: 'Edit Contact', km: 'កែប្រែទំនាក់ទំនង')
              : AppText.t(context, en: 'Add Contact', km: 'បន្ថែមទំនាក់ទំនង'),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            AppText.t(context, en: 'Contact Profile', km: 'ប្រវត្តិទំនាក់ទំនង'),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppText.t(
              context,
              en: 'Add people who should receive alerts when you trigger an SOS.',
              km: 'បន្ថែមមនុស្សដែលនឹងទទួលបានសារ ពេលអ្នកបើក SOS។',
            ),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isDarkMode ? Colors.white70 : AppColors.textGrey,
            ),
          ),

          const SizedBox(height: 18),
          Text(
            AppText.t(context, en: 'Choose Avatar', km: 'ជ្រើសរើសរូបតំណាង'),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final option in _avatarOptions)
                _AvatarChoice(
                  option: option,
                  isSelected: option == _selectedAvatar,
                  onTap: () {
                    setState(() {
                      _selectedAvatar = option;
                    });
                  },
                ),
            ],
          ),
          const SizedBox(height: 18),
          _ContactField(
            isDarkMode: isDarkMode,
            controller: _nameController,
            label: AppText.t(context, en: 'Full Name', km: 'ឈ្មោះពេញ'),
            hint: AppText.t(
              context,
              en: 'Enter contact name',
              km: 'បញ្ចូលឈ្មោះទំនាក់ទំនង',
            ),
            textInputAction: TextInputAction.next,
          ),

          const SizedBox(height: 14),
          _ContactField(
            isDarkMode: isDarkMode,
            controller: _relationshipController,
            label: AppText.t(context, en: 'Relationship', km: 'ទំនាក់ទំនង'),
            hint: AppText.t(
              context,
              en: 'Sister, Brother, Doctor...',
              km: 'បងប្អូន, វេជ្ជបណ្ឌិត...',
            ),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 14),

          _ContactField(
            controller: _phoneController,
            label: AppText.t(context, en: 'Phone Number', km: 'លេខទូរសព្ទ'),
            hint: AppText.t(
              context,
              en: '+855 xx xxx xxx',
              km: '+855 xx xxx xxx',
            ),
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.done,
            isDarkMode: isDarkMode,
          ),

          const SizedBox(height: 22),

          SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: _saveContact,
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: AppColors.primaryRed,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                _isEditing
                    ? AppText.t(
                        context,
                        en: 'SAVE CHANGES',
                        km: 'រក្សាទុកការផ្លាស់ប្តូរ',
                      )
                    : AppText.t(
                        context,
                        en: 'ADD CONTACT',
                        km: 'បន្ថែមទំនាក់ទំនង',
                      ),
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactField extends StatelessWidget {
  const _ContactField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.isDarkMode,
    this.keyboardType,
    this.textInputAction,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final bool isDarkMode;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: theme.colorScheme.onSurface,
          ),
        ),

        const SizedBox(height: 8),

        TextField(
          controller: controller,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          style: TextStyle(color: theme.colorScheme.onSurface),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: isDarkMode ? Colors.white38 : AppColors.textGrey,
            ),
            filled: true,
            fillColor: theme.colorScheme.surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: theme.dividerColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: theme.dividerColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primaryRed),
            ),
          ),
        ),
      ],
    );
  }
}

class _AvatarOption {
  const _AvatarOption({required this.label, required this.icon});

  final String label;
  final IconData icon;
}

class _AvatarChoice extends StatelessWidget {
  const _AvatarChoice({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  final _AvatarOption option;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 76,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryRed.withValues(alpha: 0.12)
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primaryRed : theme.dividerColor,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              option.icon,
              size: 20,
              color: isSelected
                  ? AppColors.primaryRed
                  : theme.colorScheme.onSurface,
            ),
            const SizedBox(height: 6),
            Text(
              option.label,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w800,
                color: isSelected
                    ? AppColors.primaryRed
                    : theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
