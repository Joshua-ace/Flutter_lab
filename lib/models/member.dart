class Member {
  final String id;
  final String name;
  final String phone;
  final String city;
  final String membershipId;
  final DateTime joinedDate;
  final String avatarUrl;
  final String role; // Member, President, Secretary, etc.
  final String tier; // Silver, Gold, Platinum VIP
  final String? bloodGroup;

  Member({
    required this.id,
    required this.name,
    required this.phone,
    required this.city,
    required this.membershipId,
    required this.joinedDate,
    this.avatarUrl = 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=400&q=80',
    this.role = 'Member',
    this.tier = 'Gold Fan',
    this.bloodGroup = 'O+',
  });

  Member copyWith({
    String? id,
    String? name,
    String? phone,
    String? city,
    String? membershipId,
    DateTime? joinedDate,
    String? avatarUrl,
    String? role,
    String? tier,
    String? bloodGroup,
  }) {
    return Member(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      city: city ?? this.city,
      membershipId: membershipId ?? this.membershipId,
      joinedDate: joinedDate ?? this.joinedDate,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      tier: tier ?? this.tier,
      bloodGroup: bloodGroup ?? this.bloodGroup,
    );
  }
}
