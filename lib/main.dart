import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:property_tax_system_fd/features/auth/data/models/user_model.dart';
import 'package:property_tax_system_fd/features/ownership/data/models/ownership_model.dart';
import 'package:property_tax_system_fd/features/properties/data/models/property_model.dart';
import 'package:property_tax_system_fd/features/valuation/data/models/valuation_model.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:property_tax_system_fd/app.dart';
import 'package:property_tax_system_fd/core/config/app_config.dart';

void main() async {
  // Initialize Flutter binding
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: '.env');

  // Initialize Sentry for crash reporting
  if (!AppConfig.isDebug && AppConfig.sentryDsn.isNotEmpty) {
    await SentryFlutter.init((options) {
      options.dsn = AppConfig.sentryDsn;
      options.tracesSampleRate = 1.0;
      options.environment = dotenv.get('ENVIRONMENT');
    }, appRunner: () => _initializeAndRunApp());
  } else {
    await _initializeAndRunApp();
  }
}

Future<void> _initializeAndRunApp() async {
  // Initialize Hive with platform-specific path
  await _initializeHive();

  // Run the app
  runApp(const ProviderScope(child: MyApp()));
}

Future<void> _initializeHive() async {
  // Get platform-specific directory
  final appDocumentDir = await getApplicationDocumentsDirectory();

  // Initialize Hive with the path
  await Hive.initFlutter(appDocumentDir.path);

  // Register all adapters
  _registerHiveAdapters();

  // Open all boxes
  await _openHiveBoxes();
}

void _registerHiveAdapters() {
  // Register Hive Type Adapters
  Hive.registerAdapter(PropertyModelAdapter());
  Hive.registerAdapter(OwnershipModelAdapter());
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(ValuationModelAdapter());
  // Hive.registerAdapter(ReportModelAdapter());
  // Hive.registerAdapter(DateRangeAdapter());
  // Hive.registerAdapter(ReportTypeAdapter());
  // Hive.registerAdapter(ReportFormatAdapter());
  // Hive.registerAdapter(ReportStatusAdapter());
  // Hive.registerAdapter(ReportDataAdapter());
  // Hive.registerAdapter(WardDataAdapter());
  // Hive.registerAdapter(PropertySummaryAdapter());
}

Future<void> _openHiveBoxes() async {
  await Future.wait([
    Hive.openBox('app_settings'),
    Hive.openBox('theme_settings'),
    Hive.openBox('user_preferences'),
    Hive.openBox('cached_properties'),
    Hive.openBox('user_data'),
  ]);
}
