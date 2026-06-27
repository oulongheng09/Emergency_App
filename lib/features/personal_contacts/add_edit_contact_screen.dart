import 'package:flutter/material.dart';

import '../../l10n/app_text.dart';
import '../../models/personal_contact_model.dart';
import '../../theme/app_colors.dart';

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
      icon: Icons.person,
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
          _DropdownRelationshipField(controller: _relationshipController),
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

class _DropdownRelationshipField extends StatelessWidget {
  const _DropdownRelationshipField({required this.controller});

  final TextEditingController controller;

  static const List<_RelationshipOption> relationships = [
    _RelationshipOption(en: 'Family', km: 'គ្រួសារ'),
    _RelationshipOption(en: 'Loved One', km: 'មនុស្សជាទីស្រឡាញ់'),
    _RelationshipOption(en: 'Doctor', km: 'វេជ្ជបណ្ឌិត'),
    _RelationshipOption(en: 'Work', km: 'ការងារ'),
  ];

  String _normalizeRelationship(String value) {
    switch (value.toLowerCase()) {
      case 'father':
      case 'mother':
      case 'brother':
      case 'sister':
      case 'family':
        return 'Family';
      case 'friend':
      case 'wife':
      case 'husband':
      case 'girlfriend':
      case 'boyfriend':
      case 'loved one':
        return 'Loved One';
      case 'doctor':
        return 'Doctor';
      case 'colleague':
      case 'boss':
      case 'work':
        return 'Work';
      default:
        return 'Family';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppText.t(context, en: 'Relationship', km: 'ទំនាក់ទំនង'),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: controller.text.isEmpty
              ? null
              : _normalizeRelationship(controller.text),
          decoration: InputDecoration(
            filled: true,
            fillColor: theme.colorScheme.surface,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: theme.dividerColor),
            ),
          ),
          hint: Text(
            AppText.t(
              context,
              en: 'Select relationship',
              km: 'ជ្រើសរើសទំនាក់ទំនង',
            ),
          ),
          items: relationships.map((item) {
            return DropdownMenuItem(
              value: item.en,
              child: Text(AppText.t(context, en: item.en, km: item.km)),
            );
          }).toList(),
          onChanged: (value) {
            controller.text = value ?? '';
          },
        ),
      ],
    );
  }
}

class _RelationshipOption {
  const _RelationshipOption({required this.en, required this.km});

  final String en;
  final String km;
}
