import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simsar_web/Models/property_model.dart';
import 'package:simsar_web/Custom_Widgets/pending_property_tile.dart';
import 'package:simsar_web/Custom_Widgets/screen_header.dart';
import 'package:simsar_web/Theme/app_colors.dart';
import 'package:simsar_web/Network/api_client.dart';

class PendingPropertiesScreen extends StatefulWidget {
  const PendingPropertiesScreen({super.key});

  @override
  State<PendingPropertiesScreen> createState() => _PendingPropertiesScreenState();
}

class _PendingPropertiesScreenState extends State<PendingPropertiesScreen> {
  
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

    final response = await DioClient.dio.get('/api/apartment/unapproved');

    final List data = response.data['users'] ?? [];

    final fetchedProperties = data.map((e) => Property.fromApiJson(e)).toList();

    setState(() {
      properties = fetchedProperties;
      hasFetched = true;
    });
  } on DioException catch (e) {
    if (e.response?.statusCode == 404) {
      setState(() {
        properties = []; 
        hasFetched = true;
        errorMessage = null; 
      });
    } else {
      setState(() {
        errorMessage = 'Failed to load properties';
        hasFetched = true;
      });
    }
  } catch (e) {
    setState(() {
      errorMessage = 'An unexpected error occurred';
      hasFetched = true;
    });
  } finally {
    setState(() {
      isLoading = false;
    });
  }
}

  Future<void> _approveProperty(int propertyId) async {
  try {
    await DioClient.dio.post(
      '/api/apartments/$propertyId/approve',
    );

    setState(() {
      properties.removeWhere((p) => p.id == propertyId);
    });

    // Optional success feedback
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Apartment approved successfully'),
        backgroundColor: SAppColors.success,
      ),
    );
  } on DioException catch (e) {
    String message = 'Something went wrong';

    if (e.response?.statusCode == 403) {
      message = 'You are not allowed to approve this apartment';
    } else if (e.response?.statusCode == 404) {
      message = 'Apartment not found';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: SAppColors.error,
      ),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Unexpected error occurred'),
        backgroundColor: Colors.red,
      ),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Container(
      color: SAppColors.background,
      width: double.infinity,
      height: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ScreenHeader(title: "Pending Properties"),

            const DescriptionBanner(
              message: "Here is a listing of all pending properties waiting for approval.",
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
                      return PendingPropertyTile(
                        property: property,
                        onTap: () {
                          context.push('/property/${property.id}');
                        },
                        onPressed: () => _approveProperty(property.id),
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
