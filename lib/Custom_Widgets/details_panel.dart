import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simsar_web/Theme/text_theme.dart';

import '../Models/property_model.dart';
import '../Theme/app_colors.dart';
import '../Custom_Widgets/details_grid.dart';
import '../Custom_Widgets/agent_card.dart';
class DetailsPanel extends StatelessWidget {
  final Property property;
  final VoidCallback onDeletePressed;
  

  const DetailsPanel({
    super.key, 
    required this.property,
    required this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.06),
            blurRadius: 20,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + Price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                property.title,
                style: STextTheme.lightTextTheme.titleLarge

              ),
              Text(
                "\$${property.pricePerDay}/month",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: SAppColors.primaryBlue,
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          Text(
            "${property.city.displayName}, ${property.province.displayName}",
            style: const TextStyle(
              fontSize: 14,
              color: SAppColors.descriptionTextGray,
            ),
          ),

          const SizedBox(height: 32),

          DetailsGrid(property: property),

          const SizedBox(height: 32),

          const Text(
            "Description",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: SAppColors.textGray),
          ),

          const SizedBox(height: 8),

          Text(
            property.description,
            style: const TextStyle(fontSize: 14, height: 1.6),
          ),

          const SizedBox(height: 32),

          AgentCard(agent: property.agent),

          const SizedBox(height: 32),

          // Delete Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: SAppColors.error,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                onDeletePressed();
                debugPrint("Delete Property ${property.id}");
              },
              child: const Text(
                "Delete Apartment",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }
}
