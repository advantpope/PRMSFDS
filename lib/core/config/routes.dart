import 'package:flutter/material.dart';
import 'package:property_tax_system_fd/features/properties/presentation/screens/add_edit_property_screen.dart';
import 'package:property_tax_system_fd/features/properties/presentation/screens/property_list_screen.dart';
import 'package:property_tax_system_fd/features/properties/presentation/screens/property_detail_screen.dart';
import 'package:property_tax_system_fd/features/properties/presentation/screens/property_map_screen.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    '/': (context) => const PropertyListScreen(),
    '/property-detail': (context) => const PropertyDetailScreen(),
    '/add-property': (context) => const AddPropertyScreen(),
    '/property-map': (context) => const PropertyMapScreen(),
    '/ownership-transfer': (context) => const OwnershipTransferScreen(),
    // Add more routes as needed
  };
}
