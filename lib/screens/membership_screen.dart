import 'package:flutter/material.dart';
import '../models/member.dart';
import '../services/database_service.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';

class MembershipScreen extends StatefulWidget {
  const MembershipScreen({super.key});

  @override
  State<MembershipScreen> createState() => _MembershipScreenState();
}

class _MembershipScreenState extends State<MembershipScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cityController = TextEditingController();
  String _selectedBloodGroup = 'O+';
  String _selectedTier = 'Gold Fan';
  bool _isSuccess = false;
  Member? _registeredMember;

  final List<String> _bloodGroups = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
  final List<String> _tiers = ['Gold Fan', 'Platinum VIP', 'Youth Wing Leader'];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newMember = Member(
        id: 'mem_${DateTime.now().millisecondsSinceEpoch}',
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        city: _cityController.text.trim(),
        membershipId: 'SKR-2026-${(DateTime.now().millisecondsSinceEpoch % 9000 + 1000)}',
        joinedDate: DateTime.now(),
        bloodGroup: _selectedBloodGroup,
        tier: _selectedTier,
      );

      DatabaseService().registerNewMember(newMember);
      AuthService().updateMember(newMember);

      setState(() {
        _isSuccess = true;
        _registeredMember = newMember;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Welcome to Srekar\'s Association! Your ID has been generated ❤️'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      appBar: AppBar(
        title: Row(
          children: const [
            Text('❤️ ', style: TextStyle(fontSize: 20)),
            Text('Join Association'),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: _isSuccess && _registeredMember != null
            ? _buildSuccessView(context, _registeredMember!)
            : _buildRegistrationForm(context),
      ),
    );
  }

  Widget _buildRegistrationForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryColor.withValues(alpha: 0.1),
                  Colors.pink.shade50.withValues(alpha: 0.5),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 26,
                  backgroundColor: AppTheme.accentHeart,
                  child: Icon(Icons.favorite, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Become an Official Member',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E1B2E),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Receive your official digital ID card, event access, and join our active charity network.',
                        style: TextStyle(fontSize: 12, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Personal Details',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name *',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Please enter your full name' : null,
                  ),
                  const SizedBox(height: 14),

                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number *',
                      prefixIcon: Icon(Icons.phone_outlined),
                    ),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Please enter your contact number' : null,
                  ),
                  const SizedBox(height: 14),

                  TextFormField(
                    controller: _cityController,
                    decoration: const InputDecoration(
                      labelText: 'City / District *',
                      prefixIcon: Icon(Icons.location_city_outlined),
                    ),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Please enter your city/district' : null,
                  ),
                  const SizedBox(height: 14),

                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: _selectedBloodGroup,
                          decoration: const InputDecoration(
                            labelText: 'Blood Group',
                            prefixIcon: Icon(Icons.bloodtype_outlined),
                          ),
                          items: _bloodGroups.map((bg) {
                            return DropdownMenuItem(value: bg, child: Text(bg));
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _selectedBloodGroup = val);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: _selectedTier,
                          decoration: const InputDecoration(
                            labelText: 'Member Tier',
                            prefixIcon: Icon(Icons.stars_outlined),
                          ),
                          items: _tiers.map((t) {
                            return DropdownMenuItem(value: t, child: Text(t, style: const TextStyle(fontSize: 13)));
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _selectedTier = val);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                      ),
                      onPressed: _submitForm,
                      icon: const Icon(Icons.verified_user_outlined),
                      label: const Text(
                        'Join & Generate Member ID',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessView(BuildContext context, Member member) {
    return Column(
      children: [
        const Icon(Icons.check_circle_rounded, color: Colors.green, size: 70),
        const SizedBox(height: 12),
        const Text(
          'Registration Successful!',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Text(
          'Welcome to Srekar\'s Association family.',
          style: TextStyle(color: Colors.grey.shade600),
        ),
        const SizedBox(height: 24),

        // Generated Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF2E0854), Color(0xFF673AB7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.purple.withValues(alpha: 0.3),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Srekar's Association",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      member.tier.toUpperCase(),
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                member.name.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'ID: ${member.membershipId} • ${member.city}',
                style: const TextStyle(color: Colors.white70, fontFamily: 'monospace'),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Blood Group: ${member.bloodGroup}',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  const Icon(Icons.qr_code_2, color: Colors.white, size: 28),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        ElevatedButton(
          onPressed: () {
            setState(() {
              _isSuccess = false;
              _nameController.clear();
              _phoneController.clear();
              _cityController.clear();
            });
          },
          child: const Text('Register Another Member'),
        ),
      ],
    );
  }
}
