import 'package:flutter/material.dart';
import 'package:devtodollars/models/restaurant.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCuisine = 'Any';
  bool _openNowOnly = false;
  bool _isLoading = false;
  List<Restaurant> _results = [];

  static const List<String> _cuisines = [
    'Any',
    'Italian',
    'Mexican',
    'Japanese',
    'Indian',
    'Mediterranean',
    'American',
    'Chinese',
    'Thai',
    'Vegan-Friendly',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    setState(() {
      _isLoading = true;
      _results = [];
    });

    // Simulate a network delay; in production this calls the Discovery Service
    await Future<void>.delayed(const Duration(seconds: 1));

    // Placeholder results to demonstrate the UI
    setState(() {
      _isLoading = false;
      _results = [
        Restaurant(
          id: '1',
          name: 'Green Bowl',
          address: '123 Main St',
          distance: 0.4,
          cuisineTag: 'Vegan-Friendly',
          rating: 4.7,
          priceRange: r'$$',
          isOpen: true,
          compatibilityScore: 92,
          safeItemCount: 18,
          recommendedItemCount: 12,
        ),
        Restaurant(
          id: '2',
          name: 'Spice Garden',
          address: '456 Oak Ave',
          distance: 0.8,
          cuisineTag: 'Indian',
          rating: 4.5,
          priceRange: r'$$',
          isOpen: true,
          compatibilityScore: 78,
          safeItemCount: 14,
          recommendedItemCount: 8,
        ),
        Restaurant(
          id: '3',
          name: 'Nori & Co.',
          address: '789 Pine Rd',
          distance: 1.2,
          cuisineTag: 'Japanese',
          rating: 4.3,
          priceRange: r'$$$',
          isOpen: false,
          compatibilityScore: 65,
          safeItemCount: 9,
          recommendedItemCount: 5,
        ),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Discover Restaurants'),
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _results.isEmpty
                    ? _buildEmptyState()
                    : _buildResultsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Neighborhood, city, or cuisine…',
              prefixIcon: const Icon(Icons.search),
              border: const OutlineInputBorder(),
              isDense: true,
              suffixIcon: IconButton(
                icon: const Icon(Icons.tune),
                onPressed: _showFilterSheet,
              ),
            ),
            onSubmitted: (_) => _search(),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _cuisines
                        .map(
                          (c) => Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: ChoiceChip(
                              label: Text(c),
                              selected: _selectedCuisine == c,
                              onSelected: (_) =>
                                  setState(() => _selectedCuisine = c),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Switch(
                value: _openNowOnly,
                onChanged: (v) => setState(() => _openNowOnly = v),
              ),
              const Text('Open now'),
              const Spacer(),
              FilledButton(
                onPressed: _search,
                child: const Text('Find Restaurants'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.restaurant_menu,
              size: 64,
              color: Theme.of(context).colorScheme.primary.withAlpha(128)),
          const SizedBox(height: 16),
          const Text(
            'Search for restaurants near you',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8),
          const Text(
            'Results are ranked by compatibility with your profile.',
            style: TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildResultsList() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _results.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) =>
          _RestaurantCard(restaurant: _results[index]),
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filters',
              style: Theme.of(ctx).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            const Text(
              'Advanced filters (price range, rating, distance) coming soon.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: Navigator.of(ctx).pop,
                child: const Text('Done'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;
  const _RestaurantCard({required this.restaurant});

  Color _scoreColor(double score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final score = restaurant.compatibilityScore ?? 0;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Compatibility score badge
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: _scoreColor(score),
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Text(
                '${score.round()}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          restaurant.name,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      if (restaurant.isOpen == true)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Open',
                            style: TextStyle(
                                color: Colors.green, fontSize: 11),
                          ),
                        )
                      else
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.red.shade100,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Closed',
                            style:
                                TextStyle(color: Colors.red, fontSize: 11),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    restaurant.address,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (restaurant.cuisineTag != null) ...[
                        Chip(
                          label: Text(restaurant.cuisineTag!),
                          padding: EdgeInsets.zero,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                        ),
                        const SizedBox(width: 4),
                      ],
                      if (restaurant.rating != null)
                        Row(
                          children: [
                            const Icon(Icons.star,
                                size: 14, color: Colors.amber),
                            Text(
                              restaurant.rating!.toStringAsFixed(1),
                              style:
                                  Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      if (restaurant.distance != null) ...[
                        const SizedBox(width: 8),
                        Text(
                          '${restaurant.distance!.toStringAsFixed(1)} mi',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${restaurant.safeItemCount ?? 0} safe items · '
                    '${restaurant.recommendedItemCount ?? 0} recommended',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.green.shade700),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
