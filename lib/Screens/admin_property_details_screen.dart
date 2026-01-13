import 'package:flutter/material.dart';
import 'package:simsar_web/Models/property_model.dart';
import 'package:simsar_web/Theme/app_colors.dart';
import 'package:simsar_web/Custom_Widgets/screen_header.dart';
import 'package:simsar_web/Custom_Widgets/agent_card.dart';
import 'package:simsar_web/Network/api_client.dart';

import '../Custom_Widgets/details_panel.dart';
import '../Custom_Widgets/main_image_viewer.dart';
import '../Custom_Widgets/thumbnail_scroller.dart';
import '../Models/property_enums.dart';

class AdminPropertyDetailsScreen extends StatelessWidget {
  final int apartmentId;

  const AdminPropertyDetailsScreen({
    super.key,
    required this.apartmentId,
  });

  Future<Property> fetchProperty(int apartmentId) async {
    //final response = await DioClient.dio.get('/api/apartments/$apartmentId');
    return Property(
      status:"",
      propertyType: PropertyType.villa,
      id: 2,
      title: "Yafour Villa",
      province: Province.damascus,
      city: City.dummar,
      reviewsAvgRating:4,
      pricePerDay: 120.0,
      images: ["assets/images/yafour_villa.jpg"],
      bedrooms: 2,
      bathrooms: 1,
      areaSqft: 450,
      buildYear: 2021,
      parking: true,
      description: "A cozy place to stay.",
      agent: Agent(
        id: 1,
        name: "John",
        avatarUrl: "",
        role: "Owner",
      ),
      reviewsCount: 10,

    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: SAppColors.background,
      width: double.infinity,
      height: double.infinity,
      child: FutureBuilder<Property>(
        future: fetchProperty(apartmentId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Failed to load property: ${snapshot.error}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final property = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ScreenHeader(title: "Property Details"),

                const SizedBox(height: 32),

                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1400),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // LEFT — Images
                        Expanded(
                          flex: 7,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MainImageViewer(imageUrl: property.images.first),
                              const SizedBox(height: 16),
                              ThumbnailScroller(images: property.images),
                            ],
                          ),
                        ),

                        const SizedBox(width: 48),

                        // RIGHT — Details
                        Expanded(
                          flex: 5,
                          child: DetailsPanel(property: property),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
