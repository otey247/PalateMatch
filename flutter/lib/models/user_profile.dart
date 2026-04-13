enum DietaryRestriction {
  vegan,
  vegetarian,
  keto,
  paleo,
  glutenFree,
  dairyFree,
  halal,
  kosher,
  lowSodium,
  lowSugar,
}

enum Allergy {
  nuts,
  shellfish,
  soy,
  dairy,
  eggs,
  gluten,
  sesame,
}

enum PreferenceStrength {
  critical,
  strong,
  preferred,
  neutral,
  avoidIfPossible,
}

class TastePreference {
  final String tag;
  final bool liked;
  final PreferenceStrength strength;

  const TastePreference({
    required this.tag,
    required this.liked,
    this.strength = PreferenceStrength.preferred,
  });

  Map<String, dynamic> toJson() => {
        'tag': tag,
        'liked': liked,
        'strength': strength.name,
      };

  factory TastePreference.fromJson(Map<String, dynamic> json) =>
      TastePreference(
        tag: json['tag'] as String,
        liked: json['liked'] as bool,
        strength: PreferenceStrength.values.firstWhere(
          (e) => e.name == json['strength'],
          orElse: () => PreferenceStrength.preferred,
        ),
      );
}

class UserProfile {
  final Set<DietaryRestriction> dietaryRestrictions;
  final Set<Allergy> allergies;
  final List<TastePreference> tastePreferences;

  const UserProfile({
    this.dietaryRestrictions = const {},
    this.allergies = const {},
    this.tastePreferences = const [],
  });

  UserProfile copyWith({
    Set<DietaryRestriction>? dietaryRestrictions,
    Set<Allergy>? allergies,
    List<TastePreference>? tastePreferences,
  }) {
    return UserProfile(
      dietaryRestrictions: dietaryRestrictions ?? this.dietaryRestrictions,
      allergies: allergies ?? this.allergies,
      tastePreferences: tastePreferences ?? this.tastePreferences,
    );
  }

  Map<String, dynamic> toJson() => {
        'dietary_restrictions':
            dietaryRestrictions.map((e) => e.name).toList(),
        'allergies': allergies.map((e) => e.name).toList(),
        'taste_preferences':
            tastePreferences.map((e) => e.toJson()).toList(),
      };

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    final restrictions = (json['dietary_restrictions'] as List<dynamic>? ?? [])
        .map((e) => DietaryRestriction.values.firstWhere(
              (r) => r.name == e,
              orElse: () => DietaryRestriction.vegan,
            ))
        .toSet();
    final allergyList = (json['allergies'] as List<dynamic>? ?? [])
        .map((e) => Allergy.values.firstWhere(
              (a) => a.name == e,
              orElse: () => Allergy.nuts,
            ))
        .toSet();
    final preferences = (json['taste_preferences'] as List<dynamic>? ?? [])
        .map((e) => TastePreference.fromJson(e as Map<String, dynamic>))
        .toList();
    return UserProfile(
      dietaryRestrictions: restrictions,
      allergies: allergyList,
      tastePreferences: preferences,
    );
  }
}
