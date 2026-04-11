import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';

class EditProfilePage extends StatefulWidget {
  final String userName;
  final String businessName;
  final String phone;
  final String instagram;
  final String city;

  const EditProfilePage({
    super.key,
    required this.userName,
    required this.businessName,
    required this.phone,
    required this.instagram,
    required this.city,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late final TextEditingController _userNameController;
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _instagramController;
  late final TextEditingController _cityController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _userNameController = TextEditingController(text: widget.userName);
    _nameController = TextEditingController(text: widget.businessName);
    _phoneController = TextEditingController(text: widget.phone);
    _instagramController = TextEditingController(text: widget.instagram);
    _cityController = TextEditingController(text: widget.city);
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _instagramController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.pop(context, {
        'userName': _userNameController.text.trim(),
        'businessName': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'instagram': _instagramController.text.trim(),
        'city': _cityController.text.trim(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l.editProfile,
          style: AppTypography.cardTitle.copyWith(fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withAlpha(30),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          _getInitials(),
                          style: AppTypography.cardTitle.copyWith(
                            fontSize: 24,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.camera_alt_rounded, size: 14, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              _buildLabel(l.fullName),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _userNameController,
                hint: l.fullNameHint,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return l.enterName;
                  return null;
                },
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 20),

              _buildLabel(l.phone),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _phoneController,
                hint: l.phoneHintFull,
                keyboardType: TextInputType.phone,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return l.enterPhoneValidation;
                  return null;
                },
              ),
              const SizedBox(height: 28),

              // Business section divider
              Text(
                l.businessInfo,
                style: AppTypography.badge.copyWith(
                  color: AppColors.textMuted,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 16),

              _buildLabel(l.businessNameLabel),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _nameController,
                hint: l.businessNameHint,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return l.enterBusinessNameValidation;
                  return null;
                },
              ),
              const SizedBox(height: 20),

              _buildLabel(l.city),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _cityController,
                hint: l.cityHint,
              ),
              const SizedBox(height: 20),

              _buildLabel(l.instagram),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _instagramController,
                hint: l.instagramHint,
              ),
              const SizedBox(height: 36),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _onSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                    textStyle: AppTypography.button.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  child: Text(l.saveChanges),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getInitials() {
    final name = _userNameController.text.trim();
    if (name.isEmpty) return '';
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: AppTypography.body.copyWith(
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
        fontSize: 13,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    ValueChanged<String>? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
      style: AppTypography.body.copyWith(
        color: AppColors.textPrimary,
        fontSize: 15,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTypography.body.copyWith(
          color: AppColors.textMuted,
          fontSize: 15,
        ),
        filled: true,
        fillColor: AppColors.background,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.danger, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.danger, width: 1.5),
        ),
      ),
    );
  }
}
