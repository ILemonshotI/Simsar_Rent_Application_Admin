import 'package:flutter/material.dart';
import 'package:simsar_web/Models/property_model.dart';
import 'package:simsar_web/Models/property_enums.dart'; 
import 'package:simsar_web/Custom_Widgets/pending_property_tile.dart';
import 'package:simsar_web/Custom_Widgets/screen_header.dart';
import 'package:simsar_web/Theme/app_colors.dart';

class PendingPropertiesScreen extends StatelessWidget {
  const PendingPropertiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Static Mock Data
    final List<Property> mockProperties = List.generate(12, (index) => _generateMockProperty(index));

    return Container(
      color: SAppColors.background,
      height: double.infinity,
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dynamic Header
            const ScreenHeader(title: "Pending Properties"),

            // Dynamic Description Banner
            const DescriptionBanner(
              message: "Here is a listing of all pending properties.",
            ),

            const SizedBox(height: 32),

            Center(
              child: Padding(
                
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Wrap(
                  alignment: WrapAlignment.center, 
                  spacing: 64, // Horizontal gap between tiles
                  runSpacing: 24, // Vertical gap between rows
                  children: mockProperties.map((property) {
                    return PendingPropertyTile(
                      property: property,
                      onTap: () => debugPrint("Clicked ${property.title}"),
                    );
                  }).toList(),
                ),
              ),
            ),
            // Optional bottom padding so the last row doesn't touch the screen edge
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // Helper method to create static data for UI testing
  Property _generateMockProperty(int id) {
    return Property(
      id: id,
      title: "Takatea Homestay",
      // These assume you have a 'displayName' or similar logic in your enums
      province: Province.damascus, 
      city: City.mazzeh,
      pricePerDay: 120.0,
      images:['assets/images/yafour_villa.jpg'] , // Placeholder image
      bedrooms: 2,
      bathrooms: 1,
      areaSqft: 1200,
      buildYear: 2022,
      parking: true,
      status: "Available",
      description: "A lovely homestay in the heart of the city.",
      propertyType: PropertyType.apartment,
      reviewsAvgRating: 4.5,
      reviewsCount: 10,
      agent: Agent(id: 1, name: "John Doe", avatarUrl: "", role: "Owner"),
    );
  }
}