enum RecommendationLabel {
  safe,
  caution,
  recommended,
  unknown,
}

class MenuItem {
  final String name;
  final String rawDescription;
  final List<String> parsedIngredients;
  final RecommendationLabel label;
  final String explanation;
  final double confidenceScore;
  final double dietMatchScore;
  final double allergyRiskScore;
  final double tasteMatchScore;

  const MenuItem({
    required this.name,
    required this.rawDescription,
    this.parsedIngredients = const [],
    this.label = RecommendationLabel.unknown,
    this.explanation = '',
    this.confidenceScore = 0.0,
    this.dietMatchScore = 0.0,
    this.allergyRiskScore = 0.0,
    this.tasteMatchScore = 0.0,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'raw_description': rawDescription,
        'parsed_ingredients': parsedIngredients,
        'label': label.name,
        'explanation': explanation,
        'confidence_score': confidenceScore,
        'diet_match_score': dietMatchScore,
        'allergy_risk_score': allergyRiskScore,
        'taste_match_score': tasteMatchScore,
      };

  factory MenuItem.fromJson(Map<String, dynamic> json) => MenuItem(
        name: json['name'] as String,
        rawDescription: json['raw_description'] as String? ?? '',
        parsedIngredients:
            List<String>.from(json['parsed_ingredients'] as List? ?? []),
        label: RecommendationLabel.values.firstWhere(
          (e) => e.name == json['label'],
          orElse: () => RecommendationLabel.unknown,
        ),
        explanation: json['explanation'] as String? ?? '',
        confidenceScore: (json['confidence_score'] as num?)?.toDouble() ?? 0.0,
        dietMatchScore: (json['diet_match_score'] as num?)?.toDouble() ?? 0.0,
        allergyRiskScore:
            (json['allergy_risk_score'] as num?)?.toDouble() ?? 0.0,
        tasteMatchScore:
            (json['taste_match_score'] as num?)?.toDouble() ?? 0.0,
      );
}
