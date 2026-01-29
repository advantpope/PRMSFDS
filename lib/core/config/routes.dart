import 'package:flutter/material.dart';
import 'package:property_tax_system_fd/features/auth/presentation/screens/login_screen.dart';
import 'package:property_tax_system_fd/features/properties/presentation/screens/property_list_screen.dart';
import 'package:property_tax_system_fd/features/ownership/presentation/screens/ownership_transfer_screen.dart';
import 'package:property_tax_system_fd/features/reports/presentation/screens/dashboard_screen.dart';
import 'package:property_tax_system_fd/features/reports/presentation/screens/report_generation_screen.dart';
import 'package:property_tax_system_fd/features/reports/presentation/screens/report_list_screen.dart';
import 'package:property_tax_system_fd/features/reports/presentation/screens/report_screen.dart';

class AppRoutes {
  static const login = '/login';
  static const dashboard = '/dashboard';
  static const properties = '/properties';
  static const ownership = '/ownership';
  static const valuation = '/valuation';
  static const taxation = '/taxation';
  static const reports = '/reports';
  static const settings = '/settings';
  static const generatereport = 'generatereport';

  static Map<String, WidgetBuilder> routes = {
    login: (_) => const LoginScreen(),
    dashboard: (_) => const DashboardScreen(),
    properties: (_) => const PropertyListScreen(),
    reports: (_) => const ReportListScreen(),
    generatereport: (_) => const ReportGenerationScreen(),

    // TEMP placeholders (until pages exist)
    valuation: (_) => const PlaceholderPage(title: 'Valuation'),
    taxation: (_) => const PlaceholderPage(title: 'Taxation'),
    settings: (_) => const PlaceholderPage(title: 'Settings'),
  };
}

class PlaceholderPage extends StatelessWidget {
  final String title;
  const PlaceholderPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('$title page coming soon')),
    );
  }
}
