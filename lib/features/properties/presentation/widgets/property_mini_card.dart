import 'package:flutter/material.dart';
import 'package:property_tax_system_fd/features/properties/data/models/property_model.dart';
import 'package:property_tax_system_fd/shared/utils/formatters.dart';

class PropertyMiniCard extends StatelessWidget {
  const PropertyMiniCard({
    super.key,
    required this.property,
    this.onTap,
    this.showTaxStatus = false,
  });
  final PropertyModel property;
  final VoidCallback? onTap;
  final bool showTaxStatus;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0,
      color: Colors.grey[50],
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Property Icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.apartment, size: 24, color: Colors.blue[600]),
              ),

              const SizedBox(width: 12),

              // Property Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Property ID
                    Text(
                      property.propertyId,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    // Address
                    Text(
                      property.address,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    // Details Row
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 10,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Ward ${property.ward}',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Icon(
                          Icons.square_foot,
                          size: 10,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          Formatters.formatArea(property.areaSqft),
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Tax Status or Value
              if (showTaxStatus && property.annualTax != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: property.annualTax! > 0
                        ? Colors.orange.withOpacity(0.2)
                        : Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    property.annualTax! > 0 ? 'Tax Due' : 'Paid',
                    style: TextStyle(
                      fontSize: 10,
                      color: property.annualTax! > 0
                          ? Colors.orange
                          : Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              else if (property.currentValuation != null)
                Text(
                  '\$${Formatters.formatCurrency(property.currentValuation!)}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
