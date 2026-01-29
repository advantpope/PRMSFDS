import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:property_tax_system_fd/core/config/routes.dart';
import 'package:property_tax_system_fd/localization/app_localizations.dart';
import 'package:property_tax_system_fd/shared/theme/app_theme.dart';
import 'package:property_tax_system_fd/features/auth/presentation/screens/login_screen.dart';
import 'package:property_tax_system_fd/features/auth/presentation/providers/auth_provider.dart';
import 'package:property_tax_system_fd/core/config/app_config.dart';
import 'package:property_tax_system_fd/features/properties/presentation/screens/property_list_screen.dart';
import 'package:property_tax_system_fd/shared/theme/theme_provider.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return MaterialApp(
      title: 'Property Tax System',
      navigatorKey: navigatorKey,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ref.watch(themeModeProvider),
      debugShowCheckedModeBanner: AppConfig.isDebug,
      locale: const Locale('en'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: _buildHome(authState),
      routes: AppRoutes.routes,
    );
  }

  Widget _buildHome(AuthState authState) {
    if (authState.isLoading) {
      return const SplashScreen();
    }
    if (authState.isAuthenticated) {
      return const MainNavigationScreen();
    }
    return const LoginScreen();
  }
}

class MainNavigationScreen extends ConsumerWidget {
  const MainNavigationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;
    final themeMode = ref.watch(themeToggleProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Property Tax System'),

        actions: [
          if (user != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  CircleAvatar(child: Text(user.firstName[0])),
                  const SizedBox(width: 8),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.fullName, style: const TextStyle(fontSize: 14)),
                      Text(
                        user.isAdmin ? 'Administrator' : 'Staff',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(
                      themeMode == ThemeMode.dark
                          ? Icons.light_mode
                          : Icons.dark_mode,
                    ),
                    onPressed: () {
                      ref.read(themeToggleProvider.notifier).toggle();
                    },
                  ),
                  if (authState.isAuthenticated)
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'logout') {
                          ref.read(authProvider.notifier).logout();
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'logout',
                          child: ListTile(
                            leading: Icon(Icons.logout),
                            title: Text('Logout'),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
        ],
      ),
      drawer: _buildDrawer(context, ref),
      body: _buildBody(context),
    );
  }

  Widget _buildDrawer(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(user?.fullName ?? 'Guest'),
            accountEmail: Text(user?.email ?? 'Not logged in'),
            currentAccountPicture: CircleAvatar(
              child: Text(user?.firstName[0] ?? 'G'),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            onTap: () {
              Navigator.pushReplacementNamed(context, AppRoutes.reports);
            },
          ),

          ListTile(
            leading: const Icon(Icons.apartment),
            title: const Text('Properties'),
            onTap: () {
              Navigator.pushReplacementNamed(context, AppRoutes.properties);
            },
          ),

          ListTile(
            leading: const Icon(Icons.swap_horiz),
            title: const Text('Ownership'),
            onTap: () {
              Navigator.pushReplacementNamed(context, AppRoutes.ownership);
            },
          ),

          ListTile(
            leading: const Icon(Icons.assessment),
            title: const Text('Valuation'),
            onTap: () {
              Navigator.pushNamed(context, '/valuation');
            },
          ),
          if (authState.isAdmin)
            ListTile(
              leading: const Icon(Icons.receipt),
              title: const Text('Taxation'),
              onTap: () {
                Navigator.pushReplacementNamed(context, AppRoutes.taxation);
              },
            ),

          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Reports'),
            onTap: () {
              Navigator.pushNamed(context, '/reports');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              ref.read(authProvider.notifier).logout();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    // Default to properties screen
    return const PropertyListScreen();
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('Loading Property Tax System...'),
          ],
        ),
      ),
    );
  }
}
