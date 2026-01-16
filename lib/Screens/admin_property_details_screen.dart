import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simsar_web/Models/property_model.dart';
import 'package:simsar_web/Theme/app_colors.dart';
import 'package:simsar_web/Custom_Widgets/screen_header.dart';
import 'package:simsar_web/Network/api_client.dart';

import '../Custom_Widgets/details_panel.dart';
import '../Custom_Widgets/main_image_viewer.dart';
import '../Custom_Widgets/thumbnail_scroller.dart';

class AdminPropertyDetailsScreen extends StatefulWidget {
  final int apartmentId;

  const AdminPropertyDetailsScreen({
    super.key,
    required this.apartmentId,
  });

  @override
  State<AdminPropertyDetailsScreen> createState() => _AdminPropertyDetailsScreenState();
}

class _AdminPropertyDetailsScreenState extends State<AdminPropertyDetailsScreen> {
  late Future<Property> _propertyFuture;

  @override
  void initState() {
    super.initState();
    _propertyFuture = fetchProperty(widget.apartmentId);
  }

  Future<Property> fetchProperty(int apartmentId) async {
    final response = await DioClient.dio.get('/api/apartments/admin/$apartmentId');
    return Property.fromJson(response.data);
  }

  // Implementation of the delete method
  Future<void> _deleteProperty() async {
    try {
      final response = await DioClient.dio.delete('/api/apartments/${widget.apartmentId}');

      if (response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Property deleted successfully'),
              backgroundColor: SAppColors.success,
            ),
          );
          // Navigate back to the previous screen after deletion
          context.pop(); 
        }
      }
    } on DioException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Delete failed: ${e.response?.data['message'] ?? 'Unknown error'}'),
            backgroundColor: SAppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // START OF THE BUILD YOU REQUESTED TO KEEP EXACTLY THE SAME
    return Container(
      color: SAppColors.background,
      width: double.infinity,
      height: double.infinity,
      child: FutureBuilder<Property>(
        future: _propertyFuture, // Using the future initialized in initState
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
                          child: DetailsPanel(property: property, onDeletePressed: _deleteProperty, ),
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
    // END OF THE BUILD
  }
}