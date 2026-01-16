import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
   bool hasFetched = false;

  @override
  void initState() {
    super.initState();
    _fetchAllApartments();
  }

  Future<void> _fetchAllApartments() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final response = await DioClient.dio.get('/api/apartments');

      final List data = response.data['data'] ?? [];

      final fetchedProperties =
          data.map((e) => Property.fromApiJson(e)).toList();

      setState(() {
        properties = fetchedProperties;
        hasFetched = true;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load properties';
        hasFetched = true;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // final List<Property> mockProperties = List.generate(12, (index) => _generateMockProperty(index));
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

            if (isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: CircularProgressIndicator(),
                ),
              )

            else if (errorMessage != null)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 60),
                  child: Text(
                    errorMessage!,
                    style: const TextStyle(color: SAppColors.error),
                  ),
                ),
              )
            else if (hasFetched && properties.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 60),
                  child: Text("No properties found"),
                ),
              )
            else
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 64,
                    runSpacing: 24,
                    children: properties.map((property) {
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
  
}
