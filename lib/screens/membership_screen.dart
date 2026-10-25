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
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cityController = TextEditingController();
  String _selectedBloodGroup = 'O+';
  String _selectedTier = 'Gold Fan';
  bool _acceptedTerms = false;
  bool _termsError = false;
  final Set<String> _selectedInterests = {'Charity & Blood Drives'};
  bool _isSuccess = false;
  Member? _registeredMember;

  final List<String> _bloodGroups = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
  final List<String> _tiers = ['Gold Fan', 'Platinum VIP', 'Youth Wing Leader'];
  final List<String> _availableInterests = [
    'Charity & Blood Drives',
    'Event Logistics',
    'Social Media Wing',
    'Cultural Meets',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  void _submitForm() {
    setState(() {
      _termsError = !_acceptedTerms;
    });

    if (_formKey.currentState!.validate() && _acceptedTerms) {
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
    } else if (!_acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please accept the Association membership terms to proceed.'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
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
                        'Experiment 7: Form design, input fields, regex validation, and error feedback.',
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
                    'Personal & Contact Details',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Name Field
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name *',
                      prefixIcon: Icon(Icons.person_outline),
                      hintText: 'e.g. John Doe',
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Please enter your full name';
                      }
                      if (v.trim().length < 3) {
                        return 'Name must be at least 3 characters long';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),

                  // Email Field
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email Address *',
                      prefixIcon: Icon(Icons.email_outlined),
                      hintText: 'e.g. member@association.org',
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Please enter your email address';
                      }
                      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                      if (!emailRegex.hasMatch(v.trim())) {
                        return 'Please enter a valid email address (e.g. name@domain.com)';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),

                  // Phone Field
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number (10 Digits) *',
                      prefixIcon: Icon(Icons.phone_outlined),
                      hintText: '9876543210',
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Please enter your contact number';
                      }
                      final phoneRegex = RegExp(r'^[0-9]{10}$');
                      if (!phoneRegex.hasMatch(v.trim())) {
                        return 'Please enter a valid 10-digit mobile number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),

                  // City Field
                  TextFormField(
                    controller: _cityController,
                    decoration: const InputDecoration(
                      labelText: 'City / District *',
                      prefixIcon: Icon(Icons.location_city_outlined),
                      hintText: 'e.g. Hyderabad',
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Please enter your city or district';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),

                  // Blood Group & Tier Row
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
                  const SizedBox(height: 18),

                  // Volunteer Wing Interests
                  const Text(
                    'Association Wings & Interests',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: _availableInterests.map((interest) {
                      final isSelected = _selectedInterests.contains(interest);
                      return FilterChip(
                        selected: isSelected,
                        label: Text(interest),
                        selectedColor: AppTheme.primaryColor.withValues(alpha: 0.2),
                        checkmarkColor: AppTheme.primaryColor,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedInterests.add(interest);
                            } else {
                              _selectedInterests.remove(interest);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // Terms and Condition Checkbox
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                      'I pledge to uphold the values and charity missions of Srekar\'s Association.',
                      style: TextStyle(fontSize: 13),
                    ),
                    value: _acceptedTerms,
                    activeColor: AppTheme.primaryColor,
                    onChanged: (val) {
                      setState(() {
                        _acceptedTerms = val ?? false;
                        if (_acceptedTerms) _termsError = false;
                      });
                    },
                    subtitle: _termsError
                        ? const Text(
                            'You must accept the terms to register',
                            style: TextStyle(color: Colors.red, fontSize: 11),
                          )
                        : null,
                    controlAffinity: ListTileControlAffinity.leading,
                  ),

                  const SizedBox(height: 20),

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
