import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:property_tax_system_fd/shared/theme/app_theme.dart';
import 'package:property_tax_system_fd/shared/theme/theme_provider.dart';
import 'package:property_tax_system_fd/shared/widgets/theme_aware_card.dart';

class ThemeSettingsScreen extends ConsumerWidget {
  const ThemeSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Theme Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Theme Mode Selection
          ThemeAwareCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Theme Mode', style: AppTheme.sectionTitleStyle),
                const SizedBox(height: 16),
                _buildThemeOption(
                  context: context,
                  title: 'Light Mode',
                  description: 'Bright theme for daytime use',
                  icon: Icons.light_mode,
                  themeMode: ThemeMode.light,
                  currentTheme: currentTheme,
                  onTap: () {
                    ref.read(themeModeProvider.notifier).state =
                        ThemeMode.light;
                  },
                ),
                const Divider(),
                _buildThemeOption(
                  context: context,
                  title: 'Dark Mode',
                  description: 'Dark theme for nighttime use',
                  icon: Icons.dark_mode,
                  themeMode: ThemeMode.dark,
                  currentTheme: currentTheme,
                  onTap: () {
                    ref.read(themeModeProvider.notifier).state = ThemeMode.dark;
                  },
                ),
                const Divider(),
                _buildThemeOption(
                  context: context,
                  title: 'System Default',
                  description: 'Follow device theme settings',
                  icon: Icons.settings,
                  themeMode: ThemeMode.system,
                  currentTheme: currentTheme,
                  onTap: () {
                    ref.read(themeModeProvider.notifier).state =
                        ThemeMode.system;
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Theme Preview
          ThemeAwareCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Theme Preview', style: AppTheme.sectionTitleStyle),
                const SizedBox(height: 16),
                _buildThemePreview(context),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Color Palette
          ThemeAwareCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Color Palette', style: AppTheme.sectionTitleStyle),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildColorSwatch(
                      color: AppTheme.primaryColor,
                      label: 'Primary',
                    ),
                    _buildColorSwatch(
                      color: AppTheme.secondaryColor,
                      label: 'Secondary',
                    ),
                    _buildColorSwatch(
                      color: AppTheme.tertiaryColor,
                      label: 'Tertiary',
                    ),
                    _buildColorSwatch(
                      color: AppTheme.successColor,
                      label: 'Success',
                    ),
                    _buildColorSwatch(
                      color: AppTheme.warningColor,
                      label: 'Warning',
                    ),
                    _buildColorSwatch(
                      color: AppTheme.errorColor,
                      label: 'Error',
                    ),
                    _buildColorSwatch(
                      color: AppTheme.propertyActiveColor,
                      label: 'Active',
                    ),
                    _buildColorSwatch(
                      color: AppTheme.propertyInactiveColor,
                      label: 'Inactive',
                    ),
                    _buildColorSwatch(
                      color: AppTheme.taxPaidColor,
                      label: 'Tax Paid',
                    ),
                    _buildColorSwatch(
                      color: AppTheme.taxDueColor,
                      label: 'Tax Due',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOption({
    required BuildContext context,
    required String title,
    required String description,
    required IconData icon,
    required ThemeMode themeMode,
    required ThemeMode currentTheme,
    required VoidCallback onTap,
  }) {
    final isSelected = currentTheme == themeMode;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.onSurface,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onSurface,
        ),
      ),
      subtitle: Text(description),
      trailing: isSelected
          ? Icon(
              Icons.check_circle,
              color: Theme.of(context).colorScheme.primary,
            )
          : null,
      onTap: onTap,
    );
  }

  Widget _buildThemePreview(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // AppBar Preview
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(8),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.menu,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                const SizedBox(width: 16),
                Text(
                  'App Title',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.search,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ],
            ),
          ),

          // Content Preview
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(8)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Button Row
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Primary'),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: () {},
                      child: const Text('Secondary'),
                    ),
                    const SizedBox(width: 8),
                    TextButton(onPressed: () {}, child: const Text('Text')),
                  ],
                ),

                const SizedBox(height: 16),

                // Cards
                Row(
                  children: [
                    Expanded(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Card 1',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Card content',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Card 2',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Card content',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Chips
                Wrap(
                  spacing: 8,
                  children: [
                    Chip(
                      label: const Text('Active'),
                      backgroundColor: context.propertyActiveColor.withOpacity(
                        0.1,
                      ),
                      labelStyle: TextStyle(color: context.propertyActiveColor),
                    ),
                    Chip(
                      label: const Text('Tax Due'),
                      backgroundColor: context.taxDueColor.withOpacity(0.1),
                      labelStyle: TextStyle(color: context.taxDueColor),
                    ),
                    Chip(
                      label: const Text('Paid'),
                      backgroundColor: context.taxPaidColor.withOpacity(0.1),
                      labelStyle: TextStyle(color: context.taxPaidColor),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorSwatch({required Color color, required String label}) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 10)),
      ],
    );
  }
}
