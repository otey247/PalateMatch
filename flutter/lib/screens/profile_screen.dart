import 'package:flutter/material.dart';
import 'package:devtodollars/models/user_profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final Set<DietaryRestriction> _selectedRestrictions = {};
  final Set<Allergy> _selectedAllergies = {};
  final List<TastePreference> _tastePreferences = [];
  final TextEditingController _preferenceController = TextEditingController();

  static const Map<DietaryRestriction, String> _restrictionLabels = {
    DietaryRestriction.vegan: 'Vegan',
    DietaryRestriction.vegetarian: 'Vegetarian',
    DietaryRestriction.keto: 'Keto',
    DietaryRestriction.paleo: 'Paleo',
    DietaryRestriction.glutenFree: 'Gluten-Free',
    DietaryRestriction.dairyFree: 'Dairy-Free',
    DietaryRestriction.halal: 'Halal',
    DietaryRestriction.kosher: 'Kosher',
    DietaryRestriction.lowSodium: 'Low-Sodium',
    DietaryRestriction.lowSugar: 'Low-Sugar',
  };

  static const Map<Allergy, String> _allergyLabels = {
    Allergy.nuts: 'Nuts',
    Allergy.shellfish: 'Shellfish',
    Allergy.soy: 'Soy',
    Allergy.dairy: 'Dairy',
    Allergy.eggs: 'Eggs',
    Allergy.gluten: 'Gluten',
    Allergy.sesame: 'Sesame',
  };

  @override
  void dispose() {
    _preferenceController.dispose();
    super.dispose();
  }

  void _addTastePreference(bool liked) {
    final tag = _preferenceController.text.trim();
    if (tag.isEmpty) return;
    setState(() {
      _tastePreferences.add(TastePreference(tag: tag, liked: liked));
      _preferenceController.clear();
    });
  }

  void _removePreference(int index) {
    setState(() => _tastePreferences.removeAt(index));
  }

  void _saveProfile() {
    final profile = UserProfile(
      dietaryRestrictions: Set.from(_selectedRestrictions),
      allergies: Set.from(_selectedAllergies),
      tastePreferences: List.from(_tastePreferences),
    );
    // In a full implementation this would persist via a provider/service
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Profile saved: '
          '${profile.dietaryRestrictions.length} restrictions, '
          '${profile.allergies.length} allergies',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('My Dining Profile'),
        actions: [
          TextButton(
            onPressed: _saveProfile,
            child: const Text('Save'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              context,
              Icons.no_food,
              'Dietary Restrictions',
              'Select all that apply',
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: DietaryRestriction.values.map((r) {
                final selected = _selectedRestrictions.contains(r);
                return FilterChip(
                  label: Text(_restrictionLabels[r] ?? r.name),
                  selected: selected,
                  onSelected: (val) => setState(() {
                    if (val) {
                      _selectedRestrictions.add(r);
                    } else {
                      _selectedRestrictions.remove(r);
                    }
                  }),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            _buildSectionHeader(
              context,
              Icons.warning_amber,
              'Allergies & Sensitivities',
              'Critical — used as hard constraints',
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: Allergy.values.map((a) {
                final selected = _selectedAllergies.contains(a);
                return FilterChip(
                  label: Text(_allergyLabels[a] ?? a.name),
                  selected: selected,
                  selectedColor:
                      Theme.of(context).colorScheme.errorContainer,
                  checkmarkColor:
                      Theme.of(context).colorScheme.onErrorContainer,
                  onSelected: (val) => setState(() {
                    if (val) {
                      _selectedAllergies.add(a);
                    } else {
                      _selectedAllergies.remove(a);
                    }
                  }),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            _buildSectionHeader(
              context,
              Icons.star,
              'Taste Preferences',
              'Add foods you love or dislike',
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _preferenceController,
                    decoration: const InputDecoration(
                      hintText: 'e.g. spicy food, onions, thin-crust pizza',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    onSubmitted: (_) => _addTastePreference(true),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  tooltip: 'I like this',
                  icon: const Icon(Icons.thumb_up),
                  onPressed: () => _addTastePreference(true),
                ),
                const SizedBox(width: 4),
                IconButton.filled(
                  tooltip: 'I dislike this',
                  style: IconButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).colorScheme.errorContainer,
                    foregroundColor:
                        Theme.of(context).colorScheme.onErrorContainer,
                  ),
                  icon: const Icon(Icons.thumb_down),
                  onPressed: () => _addTastePreference(false),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (_tastePreferences.isEmpty)
              const Text(
                'No preferences added yet.',
                style: TextStyle(color: Colors.grey),
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: _tastePreferences
                    .asMap()
                    .entries
                    .map(
                      (e) => Chip(
                        label: Text(e.value.tag),
                        avatar: Icon(
                          e.value.liked
                              ? Icons.thumb_up
                              : Icons.thumb_down,
                          size: 16,
                          color: e.value.liked
                              ? Colors.green
                              : Colors.red,
                        ),
                        onDeleted: () => _removePreference(e.key),
                      ),
                    )
                    .toList(),
              ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('Save Profile'),
                onPressed: _saveProfile,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
  ) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ],
    );
  }
}
