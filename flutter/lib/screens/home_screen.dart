import 'package:devtodollars/services/metadata_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:devtodollars/services/auth_notifier.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authNotif = ref.watch(authProvider.notifier);
    final metaAsync = ref.watch(metadataProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
        actions: [
          TextButton(
            onPressed: () => context.replaceNamed('payments'),
            child: const Text('Upgrade'),
          ),
          TextButton(
            onPressed: authNotif.signOut,
            child: const Text('Logout'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            metaAsync.when(
              data: (metadata) {
                final subscription = metadata?.subscription;
                return _WelcomeBanner(
                  name: metadata?.fullName,
                  planName: subscription?.prices?.products?.name,
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => const SizedBox.shrink(),
            ),
            const SizedBox(height: 24),
            Text(
              'What would you like to do?',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _FeatureCard(
              icon: Icons.restaurant_menu,
              title: 'Discover Restaurants',
              description:
                  'Find nearby restaurants ranked by compatibility with your dietary profile.',
              color: Colors.green,
              onTap: () => context.pushNamed('discover'),
            ),
            const SizedBox(height: 12),
            _FeatureCard(
              icon: Icons.document_scanner,
              title: 'Scan a Menu',
              description:
                  'Upload or photograph any menu and get Safe / Caution / Recommended labels instantly.',
              color: Colors.blue,
              onTap: () => context.pushNamed('menuScan'),
            ),
            const SizedBox(height: 12),
            _FeatureCard(
              icon: Icons.group,
              title: 'Group Dining',
              description:
                  'Coordinate with friends and find the best restaurant for your whole group.',
              color: Colors.purple,
              onTap: () => context.pushNamed('groupSession'),
            ),
            const SizedBox(height: 12),
            _FeatureCard(
              icon: Icons.manage_accounts,
              title: 'My Dining Profile',
              description:
                  'Manage your dietary restrictions, allergies, and taste preferences.',
              color: Colors.orange,
              onTap: () => context.pushNamed('profile'),
            ),
          ],
        ),
      ),
    );
  }
}

class _WelcomeBanner extends StatelessWidget {
  final String? name;
  final String? planName;

  const _WelcomeBanner({this.name, this.planName});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primaryContainer,
            Theme.of(context).colorScheme.secondaryContainer,
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name != null ? 'Welcome back, $name 👋' : 'Welcome to PalateMatch 👋',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            planName != null
                ? 'You are on the $planName plan.'
                : 'Your AI-powered dining companion.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final VoidCallback onTap;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: color.withAlpha(30),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
