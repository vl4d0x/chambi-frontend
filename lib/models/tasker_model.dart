import 'user_model.dart';

class TaskerModel extends AppUser {
  final List<String> skills;
  final String? bio;
  final List<String> portfolioUrls;
  final double rating;
  final int reviewCount;

  const TaskerModel({
    required super.id,
    required super.name,
    required super.email,
    super.avatarUrl,
    super.phone,
    super.location,
    this.skills = const [],
    this.bio,
    this.portfolioUrls = const [],
    this.rating = 0.0,
    this.reviewCount = 0,
  });

  @override
  UserRole get role => UserRole.tasker;

  TaskerModel copyWith({
    String? name,
    String? avatarUrl,
    String? phone,
    AddressModel? location,
    List<String>? skills,
    String? bio,
    List<String>? portfolioUrls,
  }) {
    return TaskerModel(
      id: id,
      name: name ?? this.name,
      email: email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      phone: phone ?? this.phone,
      location: location ?? this.location,
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
