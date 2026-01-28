import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:geolocator/geolocator.dart';

import 'package:property_tax_system_fd/core/services/location_service.dart';
import 'package:property_tax_system_fd/features/properties/data/models/property_model.dart';
import 'package:property_tax_system_fd/features/properties/presentation/providers/property_provider.dart';

class PropertyMapScreen extends ConsumerStatefulWidget {
  const PropertyMapScreen({super.key});

  @override
  ConsumerState<PropertyMapScreen> createState() => _PropertyMapScreenState();
}

class _PropertyMapScreenState extends ConsumerState<PropertyMapScreen> {
  GoogleMapController? _mapController;
  final CustomInfoWindowController _infoWindowController =
      CustomInfoWindowController();

  Position? _currentPosition;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      final position = await LocationService.getCurrentPosition();
      setState(() {
        _currentPosition = position;
      });
      _loadPropertiesOnMap();
    } catch (e) {
      debugPrint('Location error: $e');
    }
  }

  void _loadPropertiesOnMap() {
    final state = ref.read(propertyProvider);

    state.when(
      data: (properties) {
        final markers = properties.map((property) {
          return Marker(
            markerId: MarkerId(property.id.toString()),
            position: LatLng(property.latitude, property.longitude),
            onTap: () {
              _infoWindowController.addInfoWindow!(
                _buildInfoWindow(property),
                LatLng(property.latitude, property.longitude),
              );
            },
          );
        }).toSet();

        setState(() {
          _markers = markers;
        });
      },
      loading: () {},
      error: (_, __) {},
    );
  }

  Widget _buildInfoWindow(PropertyModel property) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            property.propertyId,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(property.address, maxLines: 2, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Text(
            'Owner: ${property.currentOwner?.ownerName ?? 'N/A'}',
            style: const TextStyle(fontSize: 12),
          ),
          Text(
            'Value: \$${property.currentValuation?.toStringAsFixed(2) ?? '0.00'}',
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Property Map')),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _currentPosition != null
                  ? LatLng(
                      _currentPosition!.latitude,
                      _currentPosition!.longitude,
                    )
                  : const LatLng(0, 0),
              zoom: 14,
            ),
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            onMapCreated: (controller) {
              _mapController = controller;
              _infoWindowController.googleMapController = controller;
            },
            onTap: (_) => _infoWindowController.hideInfoWindow!(),
            onCameraMove: (_) => _infoWindowController.onCameraMove!(),
          ),
          CustomInfoWindow(
            controller: _infoWindowController,
            height: 120,
            width: 220,
            offset: 40,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _infoWindowController.dispose();
    super.dispose();
  }
}
