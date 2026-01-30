import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:property_tax_system_fd/features/auth/data/models/user_model.dart';
import 'package:property_tax_system_fd/features/ownership/data/models/ownership_model.dart';
import 'package:property_tax_system_fd/features/properties/data/models/property_model.dart';
import 'package:property_tax_system_fd/features/valuation/data/models/valuation_model.dart';
import 'package:property_tax_system_fd/app.dart';

void main() async {
  // Initialize Flutter binding
  WidgetsFlutterBinding.ensureInitialized();

  print('🚀 Starting Property Tax System...');

  try {
    // Initialize Hive
    await Hive.initFlutter();

    print('✅ Hive initialized successfully');
  } catch (e) {
    print('⚠️ Hive initialization warning: $e');
  }

  try {
    // Try to open boxes, but don't crash if it fails
    await Hive.openBox('auth_data');
    await Hive.openBox('property_data');
    print('✅ Hive boxes opened');
  } catch (e) {
    print('⚠️ Could not open Hive boxes: $e');
    // Continue anyway - we can use mock data
  }

  // Run the app
  runApp(const ProviderScope(child: MyApp()));
}
