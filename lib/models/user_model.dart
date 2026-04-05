enum UserRole { contractor, tasker }

enum AuthStatus { unauthenticated, authenticated }

class UserModel {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String? avatarUrl;

  // Contractor-specific
  final String? address;
  final String? city;
  final String? zipCode;

  // Tasker-specific
  final List<String> skills;
  final String? bio;
  final List<String> portfolioUrls;
  final double rating;
  final int reviewCount;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.avatarUrl,
    this.address,
    this.city,
    this.zipCode,
    this.skills = const [],
    this.bio,
    this.portfolioUrls = const [],
    this.rating = 0.0,
    this.reviewCount = 0,
  });

  UserModel copyWith({
    String? name,
    String? avatarUrl,
    String? address,
    String? city,
    String? zipCode,
    List<String>? skills,
    String? bio,
    List<String>? portfolioUrls,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      email: email,
      role: role,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      address: address ?? this.address,
      city: city ?? this.city,
      zipCode: zipCode ?? this.zipCode,
      skills: skills ?? this.skills,
      bio: bio ?? this.bio,
      portfolioUrls: portfolioUrls ?? this.portfolioUrls,
      rating: rating,
      reviewCount: reviewCount,
    );
  }
}

/// Available skill categories for taskers
class SkillCategories {
  static const List<String> all = [
    'Cleaning',
    'Plumbing',
    'Electrical',
    'Painting',
    'Moving',
    'Furniture Assembly',
    'Gardening',
    'Handyman',
    'Carpentry',
    'HVAC',
    'Appliance Repair',
    'Pest Control',
    'Locksmith',
    'Roofing',
    'Tiling',
  ];
}
