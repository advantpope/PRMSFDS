import 'package:flutter/material.dart';
import 'package:property_tax_system_fd/features/properties/data/models/property_model.dart';
import 'package:property_tax_system_fd/shared/utils/formatters.dart';

class PropertyGridCard extends StatelessWidget {
  const PropertyGridCard({super.key, required this.property, this.onTap});
  final PropertyModel property;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(4),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Property Image or Placeholder
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(8),
                ),
                color: Colors.blue[50],
                image: property.images.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(property.images.first),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: property.images.isEmpty
                  ? Center(
                      child: Icon(
                        Icons.apartment,
                        size: 40,
                        color: Colors.blue[200],
                      ),
                    )
                  : null,
            ),

            // Property Info
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Property ID
                  Text(
                    property.propertyId,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // Address
                  Text(
                    property.address,
                    style: const TextStyle(fontSize: 10, color: Colors.black87),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 4),

                  // Property Type and Area
                  Row(
                    children: [
                      const Icon(Icons.category, size: 10, color: Colors.grey),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          Formatters.formatPropertyType(property.propertyType),
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      const Icon(
                        Icons.square_foot,
                        size: 10,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        Formatters.formatArea(property.areaSqft),
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),

                  const Divider(height: 8),

                  // Valuation and Status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Value',
                            style: TextStyle(
                              fontSize: 8,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            property.currentValuation != null
                                ? '\$${Formatters.formatCurrency(property.currentValuation!)}'
                                : 'N/A',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      // Status Dot
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: property.isActive ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
