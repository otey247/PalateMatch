import 'package:flutter/material.dart';
import 'package:devtodollars/models/menu_item.dart';

class MenuScanScreen extends StatefulWidget {
  const MenuScanScreen({super.key});

  @override
  State<MenuScanScreen> createState() => _MenuScanScreenState();
}

class _MenuScanScreenState extends State<MenuScanScreen> {
  bool _isAnalyzing = false;
  bool _hasResult = false;
  List<MenuItem> _menuItems = [];

  Future<void> _analyzeMenu() async {
    setState(() {
      _isAnalyzing = true;
      _hasResult = false;
      _menuItems = [];
    });

    // Simulate OCR + LLM processing delay
    await Future<void>.delayed(const Duration(seconds: 2));

    // Placeholder results demonstrating Safe/Caution/Recommended labels
    setState(() {
      _isAnalyzing = false;
      _hasResult = true;
      _menuItems = const [
        MenuItem(
          name: 'Spicy Tofu Rice Bowl',
          rawDescription:
              'Crispy tofu, jasmine rice, edamame, sriracha glaze, sesame seeds',
          parsedIngredients: [
            'tofu',
            'jasmine rice',
            'edamame',
            'sriracha',
            'sesame seeds',
          ],
          label: RecommendationLabel.recommended,
          explanation:
              'Recommended: vegan, high-protein, spicy seasoning matches your taste profile.',
          confidenceScore: 0.92,
          dietMatchScore: 0.95,
          allergyRiskScore: 0.05,
          tasteMatchScore: 0.90,
        ),
        MenuItem(
          name: 'Avocado Miso Salad',
          rawDescription:
              'Mixed greens, avocado, cucumber, miso-ginger dressing',
          parsedIngredients: [
            'mixed greens',
            'avocado',
            'cucumber',
            'miso',
            'ginger',
          ],
          label: RecommendationLabel.recommended,
          explanation:
              'Recommended: vegan, gluten-free, light and fresh.',
          confidenceScore: 0.95,
          dietMatchScore: 0.97,
          allergyRiskScore: 0.02,
          tasteMatchScore: 0.85,
        ),
        MenuItem(
          name: 'Teriyaki Chicken Bowl',
          rawDescription:
              'Grilled chicken, steamed rice, teriyaki sauce, sesame',
          parsedIngredients: [
            'chicken',
            'steamed rice',
            'teriyaki sauce',
            'sesame',
          ],
          label: RecommendationLabel.caution,
          explanation:
              'Caution: teriyaki sauce may contain soy and sesame allergens. Confirm with staff.',
          confidenceScore: 0.78,
          dietMatchScore: 0.60,
          allergyRiskScore: 0.45,
          tasteMatchScore: 0.70,
        ),
        MenuItem(
          name: 'Shrimp Fried Rice',
          rawDescription: 'Wok-fried rice, shrimp, egg, soy sauce, scallions',
          parsedIngredients: [
            'shrimp',
            'rice',
            'egg',
            'soy sauce',
            'scallions',
          ],
          label: RecommendationLabel.safe,
          explanation:
              'Safe: contains shellfish — if you have a shellfish allergy, avoid this item.',
          confidenceScore: 0.88,
          dietMatchScore: 0.50,
          allergyRiskScore: 0.80,
          tasteMatchScore: 0.60,
        ),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Menu Scan'),
      ),
      body: _isAnalyzing
          ? _buildAnalyzingState()
          : !_hasResult
              ? _buildUploadState()
              : _buildResultState(),
    );
  }

  Widget _buildUploadState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.document_scanner,
              size: 80,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              'Scan a Menu',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Upload or capture a photo of any restaurant menu. '
              'PalateMatch will extract items and highlight what\'s safe, '
              'what to avoid, and what\'s recommended — just for you.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ActionButton(
                  icon: Icons.camera_alt,
                  label: 'Take Photo',
                  onTap: _analyzeMenu,
                ),
                const SizedBox(width: 16),
                _ActionButton(
                  icon: Icons.photo_library,
                  label: 'Upload Image',
                  onTap: _analyzeMenu,
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'PalateMatch never claims medical certainty.\n'
              'Always confirm allergy-sensitive choices with restaurant staff.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyzingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 24),
          Text(
            'Analyzing menu…',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 8),
          Text(
            'Running OCR and AI recommendation engine',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildResultState() {
    final recommended =
        _menuItems.where((i) => i.label == RecommendationLabel.recommended);
    final safe =
        _menuItems.where((i) => i.label == RecommendationLabel.safe);
    final caution =
        _menuItems.where((i) => i.label == RecommendationLabel.caution);

    return Column(
      children: [
        Container(
          color: Theme.of(context).colorScheme.primaryContainer,
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _SummaryBadge(
                icon: Icons.recommend,
                label: 'Recommended',
                count: recommended.length,
                color: Colors.green,
              ),
              _SummaryBadge(
                icon: Icons.check_circle,
                label: 'Safe',
                count: safe.length,
                color: Colors.blue,
              ),
              _SummaryBadge(
                icon: Icons.warning_amber,
                label: 'Caution',
                count: caution.length,
                color: Colors.orange,
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: _menuItems.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (_, i) => _MenuItemCard(item: _menuItems[i]),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.refresh),
                    label: const Text('Scan Another'),
                    onPressed: () => setState(() => _hasResult = false),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 130,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          border: Border.all(
              color: Theme.of(context).colorScheme.primary, width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon,
                size: 36, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;
  final Color color;

  const _SummaryBadge({
    required this.icon,
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 4),
        Text(
          '$count',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: color),
        ),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

class _MenuItemCard extends StatelessWidget {
  final MenuItem item;
  const _MenuItemCard({required this.item});

  Color get _labelColor {
    switch (item.label) {
      case RecommendationLabel.recommended:
        return Colors.green;
      case RecommendationLabel.safe:
        return Colors.blue;
      case RecommendationLabel.caution:
        return Colors.orange;
      case RecommendationLabel.unknown:
        return Colors.grey;
    }
  }

  IconData get _labelIcon {
    switch (item.label) {
      case RecommendationLabel.recommended:
        return Icons.recommend;
      case RecommendationLabel.safe:
        return Icons.check_circle_outline;
      case RecommendationLabel.caution:
        return Icons.warning_amber;
      case RecommendationLabel.unknown:
        return Icons.help_outline;
    }
  }

  String get _labelText {
    switch (item.label) {
      case RecommendationLabel.recommended:
        return 'Recommended';
      case RecommendationLabel.safe:
        return 'Safe';
      case RecommendationLabel.caution:
        return 'Caution';
      case RecommendationLabel.unknown:
        return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    item.name,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _labelColor.withAlpha(30),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: _labelColor, width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(_labelIcon, size: 14, color: _labelColor),
                      const SizedBox(width: 4),
                      Text(
                        _labelText,
                        style: TextStyle(
                            color: _labelColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (item.rawDescription.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                item.rawDescription,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            const SizedBox(height: 8),
            Text(
              item.explanation,
              style: TextStyle(
                  color: _labelColor, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: item.confidenceScore,
              backgroundColor: Colors.grey.shade200,
              color: _labelColor,
              minHeight: 4,
              borderRadius: BorderRadius.circular(2),
            ),
            const SizedBox(height: 2),
            Text(
              'Confidence: ${(item.confidenceScore * 100).round()}%',
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
