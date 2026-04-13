class Restaurant {
  final String id;
  final String name;
  final String address;
  final double? distance;
  final String? cuisineTag;
  final double? rating;
  final String? priceRange;
  final String? phoneNumber;
  final String? website;
  final bool? isOpen;
  final double? compatibilityScore;
  final int? safeItemCount;
  final int? recommendedItemCount;
  final String? photoUrl;

  const Restaurant({
    required this.id,
    required this.name,
    required this.address,
    this.distance,
    this.cuisineTag,
    this.rating,
    this.priceRange,
    this.phoneNumber,
    this.website,
    this.isOpen,
    this.compatibilityScore,
    this.safeItemCount,
    this.recommendedItemCount,
    this.photoUrl,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'address': address,
        'distance': distance,
        'cuisine_tag': cuisineTag,
        'rating': rating,
        'price_range': priceRange,
        'phone_number': phoneNumber,
        'website': website,
        'is_open': isOpen,
        'compatibility_score': compatibilityScore,
        'safe_item_count': safeItemCount,
        'recommended_item_count': recommendedItemCount,
        'photo_url': photoUrl,
      };

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
        id: json['id'] as String,
        name: json['name'] as String,
        address: json['address'] as String,
        distance: (json['distance'] as num?)?.toDouble(),
        cuisineTag: json['cuisine_tag'] as String?,
        rating: (json['rating'] as num?)?.toDouble(),
        priceRange: json['price_range'] as String?,
        phoneNumber: json['phone_number'] as String?,
        website: json['website'] as String?,
        isOpen: json['is_open'] as bool?,
        compatibilityScore:
            (json['compatibility_score'] as num?)?.toDouble(),
        safeItemCount: json['safe_item_count'] as int?,
        recommendedItemCount: json['recommended_item_count'] as int?,
        photoUrl: json['photo_url'] as String?,
      );
}
