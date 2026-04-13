import 'package:flutter/material.dart';
import 'package:devtodollars/models/restaurant.dart';

enum SessionState { lobby, browsing, selected }

class GroupMember {
  final String name;
  final String emoji;
  final int safeOptions;

  const GroupMember({
    required this.name,
    required this.emoji,
    required this.safeOptions,
  });
}

class GroupSessionScreen extends StatefulWidget {
  const GroupSessionScreen({super.key});

  @override
  State<GroupSessionScreen> createState() => _GroupSessionScreenState();
}

class _GroupSessionScreenState extends State<GroupSessionScreen> {
  SessionState _sessionState = SessionState.lobby;
  final TextEditingController _nameController = TextEditingController();
  final List<GroupMember> _members = [];
  Restaurant? _selectedRestaurant;

  static const List<String> _emojis = [
    '🧑',
    '👩',
    '👨',
    '🧔',
    '👱',
    '🧕',
    '👳',
    '🧛',
  ];

  // Mock restaurants ranked by group compatibility
  static const List<Restaurant> _mockRestaurants = [
    Restaurant(
      id: '1',
      name: 'Green Bowl',
      address: '123 Main St',
      cuisineTag: 'Vegan-Friendly',
      rating: 4.7,
      priceRange: r'$$',
      compatibilityScore: 89,
      safeItemCount: 18,
      recommendedItemCount: 12,
    ),
    Restaurant(
      id: '2',
      name: 'Spice Garden',
      address: '456 Oak Ave',
      cuisineTag: 'Indian',
      rating: 4.5,
      priceRange: r'$$',
      compatibilityScore: 76,
      safeItemCount: 14,
      recommendedItemCount: 8,
    ),
    Restaurant(
      id: '3',
      name: 'Nori & Co.',
      address: '789 Pine Rd',
      cuisineTag: 'Japanese',
      rating: 4.3,
      priceRange: r'$$$',
      compatibilityScore: 64,
      safeItemCount: 9,
      recommendedItemCount: 5,
    ),
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _joinSession() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    setState(() {
      _members.add(GroupMember(
        name: name,
        emoji: _emojis[_members.length % _emojis.length],
        safeOptions: 10 + (_members.length * 3),
      ));
      _nameController.clear();
    });
  }

  void _startBrowsing() {
    if (_members.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Add at least one member to start.')),
      );
      return;
    }
    setState(() => _sessionState = SessionState.browsing);
  }

  void _selectRestaurant(Restaurant r) {
    setState(() {
      _selectedRestaurant = r;
      _sessionState = SessionState.selected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Group Dining Session'),
        actions: [
          if (_sessionState != SessionState.lobby)
            TextButton(
              onPressed: () => setState(() {
                _sessionState = SessionState.lobby;
                _selectedRestaurant = null;
              }),
              child: const Text('New Session'),
            ),
        ],
      ),
      body: switch (_sessionState) {
        SessionState.lobby => _buildLobby(),
        SessionState.browsing => _buildBrowsing(),
        SessionState.selected => _buildSelected(),
      },
    );
  }

  // ── Lobby ─────────────────────────────────────────────────────────────────

  Widget _buildLobby() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(
            icon: Icons.group_add,
            title: 'Create a Group Session',
            subtitle: 'Add everyone who is dining together',
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    hintText: 'Member name',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  onSubmitted: (_) => _joinSession(),
                ),
              ),
              const SizedBox(width: 8),
              FilledButton.icon(
                icon: const Icon(Icons.person_add),
                label: const Text('Add'),
                onPressed: _joinSession,
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_members.isEmpty)
            const Center(
              child: Text(
                'No members yet.',
                style: TextStyle(color: Colors.grey),
              ),
            )
          else ...[
            Text(
              '${_members.length} member${_members.length > 1 ? 's' : ''} in session',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            ..._members.map(
              (m) => ListTile(
                leading: Text(m.emoji, style: const TextStyle(fontSize: 24)),
                title: Text(m.name),
                subtitle: Text('${m.safeOptions} estimated safe options'),
                trailing: IconButton(
                  icon: const Icon(Icons.remove_circle_outline,
                      color: Colors.red),
                  onPressed: () =>
                      setState(() => _members.remove(m)),
                ),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              icon: const Icon(Icons.restaurant_menu),
              label: const Text('Find Restaurants for Group'),
              onPressed: _startBrowsing,
            ),
          ),
        ],
      ),
    );
  }

  // ── Browsing ───────────────────────────────────────────────────────────────

  Widget _buildBrowsing() {
    return Column(
      children: [
        _buildMemberBar(),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: _mockRestaurants.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (ctx, i) => _GroupRestaurantCard(
              restaurant: _mockRestaurants[i],
              memberCount: _members.length,
              onSelect: () => _selectRestaurant(_mockRestaurants[i]),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMemberBar() {
    return Container(
      color: Theme.of(context).colorScheme.primaryContainer,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.group, size: 18),
          const SizedBox(width: 4),
          Text(
            '${_members.length} member${_members.length > 1 ? 's' : ''}',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _members
                    .map((m) => Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Chip(
                            label: Text('${m.emoji} ${m.name}'),
                            visualDensity: VisualDensity.compact,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ),
                        ))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Selected ───────────────────────────────────────────────────────────────

  Widget _buildSelected() {
    final r = _selectedRestaurant!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            color: Colors.green.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 32),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Venue Selected!',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(r.name),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Personalized Picks',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ..._members.map(
            (m) => Card(
              child: ListTile(
                leading: Text(m.emoji, style: const TextStyle(fontSize: 24)),
                title: Text(m.name),
                subtitle: const Text(
                    'Push recommendations sent — tap to see picks'),
                trailing:
                    const Icon(Icons.notifications_active, color: Colors.green),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Each member has received personalized menu item '
                      'recommendations based on their dietary profile.',
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
}

// ── Supporting widgets ────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _SectionTitle({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ],
    );
  }
}

class _GroupRestaurantCard extends StatelessWidget {
  final Restaurant restaurant;
  final int memberCount;
  final VoidCallback onSelect;

  const _GroupRestaurantCard({
    required this.restaurant,
    required this.memberCount,
    required this.onSelect,
  });

  Color _scoreColor(double s) {
    if (s >= 80) return Colors.green;
    if (s >= 60) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final score = restaurant.compatibilityScore ?? 0.0;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
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
                        fontSize: 18),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        restaurant.name,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        restaurant.cuisineTag ?? '',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                FilledButton(
                  onPressed: onSelect,
                  child: const Text('Select'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.people,
                    size: 14,
                    color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(
                  'Safe for all $memberCount members',
                  style: const TextStyle(fontSize: 12),
                ),
                const Spacer(),
                const Icon(Icons.star, size: 14, color: Colors.amber),
                const SizedBox(width: 2),
                Text(
                  restaurant.rating?.toStringAsFixed(1) ?? '—',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '${restaurant.safeItemCount ?? 0} safe · '
              '${restaurant.recommendedItemCount ?? 0} recommended across all profiles',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.green.shade700),
            ),
          ],
        ),
      ),
    );
  }
}
