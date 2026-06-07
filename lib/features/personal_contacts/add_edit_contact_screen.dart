import 'package:emergency_front_end/models/personal_contact_model.dart';
import 'package:emergency_front_end/theme/app_colors.dart';
import 'package:flutter/material.dart';

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
  late _ContactAvatarOption _selectedAvatar;

  bool get _isEditing => widget.contact != null;

  static const _avatarOptions = [
    _ContactAvatarOption(
      icon: Icons.person_rounded,
      color: AppColors.policeBlue,
      label: 'Family',
    ),
    _ContactAvatarOption(
      icon: Icons.favorite_rounded,
      color: Color(0xFF8B5E2E),
      label: 'Loved One',
    ),
    _ContactAvatarOption(
      icon: Icons.medical_services_rounded,
      color: AppColors.textGrey,
      label: 'Doctor',
    ),
    _ContactAvatarOption(
      icon: Icons.work_rounded,
      color: AppColors.fireOrange,
      label: 'Work',
    ),
  ];

  @override
  void initState() {
    super.initState();
    final contact = widget.contact;
    _nameController = TextEditingController(text: contact?.name ?? '');
    _relationshipController = TextEditingController(
      text: contact?.relationship ?? '',
    );
    _phoneController = TextEditingController(text: contact?.phone ?? '');
    _selectedAvatar = _avatarOptions.firstWhere(
      (option) =>
          option.icon == contact?.icon && option.color == contact?.iconColor,
      orElse: () => _avatarOptions.first,
    );
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
        const SnackBar(content: Text('Please fill in all contact fields.')),
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
      iconColor: _selectedAvatar.color,
    );

    Navigator.of(context).pop(contact);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textDark,
        elevation: 0,
        title: Text(_isEditing ? 'Edit Contact' : 'Add Contact'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Contact Profile',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Add people who should receive alerts when you trigger an SOS.',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textGrey,
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Choose Avatar',
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
            controller: _nameController,
            label: 'Full Name',
            hint: 'Enter contact name',
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 14),
          _ContactField(
            controller: _relationshipController,
            label: 'Relationship',
            hint: 'Sister, Brother, Doctor...',
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 14),
          _ContactField(
            controller: _phoneController,
            label: 'Phone Number',
            hint: '+855 xx xxx xxx',
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.done,
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
                _isEditing ? 'SAVE CHANGES' : 'ADD CONTACT',
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
    this.keyboardType,
    this.textInputAction,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border),
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

class _AvatarChoice extends StatelessWidget {
  const _AvatarChoice({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  final _ContactAvatarOption option;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 74,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primaryRed : AppColors.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: option.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(option.icon, color: option.color, size: 18),
            ),
            const SizedBox(height: 8),
            Text(
              option.label,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactAvatarOption {
  const _ContactAvatarOption({
    required this.icon,
    required this.color,
    required this.label,
  });

  final IconData icon;
  final Color color;
  final String label;
}
