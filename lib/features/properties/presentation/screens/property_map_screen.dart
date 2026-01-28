import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:geolocator/geolocator.dart';
import 'package:property_tax_system_fd/features/properties/presentation/providers/property_provider.dart';
import 'package:property_tax_system_fd/features/properties/data/models/property_model.dart';
import 'package:property_tax_system_fd/core/services/location_service.dart';

class PropertyMapScreen extends ConsumerStatefulWidget {
  const PropertyMapScreen({super.key});

  @override
  ConsumerState<PropertyMapScreen> createState() => _PropertyMapScreenState();
}

class _PropertyMapScreenState extends ConsumerState<PropertyMapScreen> {
  late GoogleMapController _mapController;
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
    final position = await LocationService.getCurrentPosition();
    setState(() {
      _currentPosition = position;
    });
    _loadPropertiesOnMap();
  }

  void _loadPropertiesOnMap() {
    final properties = ref.read(propertyProvider).value ?? [];

    final markers = properties.map((property) {
      return Marker(
        markerId: MarkerId(property.id),
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
  }

  Widget _buildInfoWindow(PropertyModel property) {
    return Container(
      width: 200,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            property.propertyId,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(property.address),
          Text('Owner: ${property.ownerName}'),
          Text('Value: \$${property.valuationAmount.toStringAsFixed(2)}'),
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
              zoom: 15,
            ),
            markers: _markers,
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
              _infoWindowController.googleMapController = controller;
            },
            onTap: (position) {
              _infoWindowController.hideInfoWindow!();
            },
            onCameraMove: (position) {
              _infoWindowController.onCameraMove!();
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),
          CustomInfoWindow(
            controller: _infoWindowController,
            height: 100,
            width: 200,
            offset: 50,
          ),
        ],
      ),
    );
  }
}
