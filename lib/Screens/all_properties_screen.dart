import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simsar_web/Models/property_enums.dart';
import 'package:simsar_web/Models/property_model.dart';
import 'package:simsar_web/Custom_Widgets/property_tile.dart';
import 'package:simsar_web/Custom_Widgets/screen_header.dart';
import 'package:simsar_web/Theme/app_colors.dart';
import 'package:simsar_web/Network/api_client.dart';

class AllPropertiesScreen extends StatefulWidget {
  const AllPropertiesScreen({super.key});

  @override
  State<AllPropertiesScreen> createState() => _AllPropertiesScreenState();
}

class _AllPropertiesScreenState extends State<AllPropertiesScreen> {
  
   List<Property> properties = [];
   bool isLoading = false;
   String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchAllApartments();
  }

  Future<void> _fetchAllApartments() async {
    try {
      setState(() {
        isLoading = false;
        errorMessage = null;
      });

      final response = await DioClient.dio.get('/api/apartments');

      final List data = response.data['data'] ?? [];

      final fetchedProperties =
          data.map((e) => Property.fromApiJson(e)).toList();

      setState(() {
        properties = fetchedProperties;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load properties';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Property> mockProperties = List.generate(12, (index) => _generateMockProperty(index));
    return Container(
      color: SAppColors.background,
      width: double.infinity,
      height: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ScreenHeader(title: "Property Listings"),

            const DescriptionBanner(
              message: "Here is a listing of all available properties.",
            ),

            const SizedBox(height: 32),

            // if (isLoading)
            //   const Center(
            //     child: Padding(
            //       padding: EdgeInsets.symmetric(vertical: 60),
            //       child: CircularProgressIndicator(),
            //     ),
            //   )
            // else if (errorMessage != null)
            //   Center(
            //     child: Padding(
            //       padding: const EdgeInsets.symmetric(vertical: 60),
            //       child: Text(
            //         errorMessage!,
            //         style: const TextStyle(color: SAppColors.error),
            //       ),
            //     ),
            //   )
            // else if (mockProperties.isEmpty)
            //   const Center(
            //     child: Padding(
            //       padding: EdgeInsets.symmetric(vertical: 60),
            //       child: Text("No properties found"),
            //     ),
            //   )
            // else
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 64,
                    runSpacing: 24,
                    children: mockProperties.map((property) {
                      return PropertyTile(
                        property: property,
                        onTap: () {
                          context.push('/property/${property.id}');
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
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
