import 'package:flutter/cupertino.dart';

import '../Models/property_model.dart';
import 'package:simsar_web/Theme/app_colors.dart';
class DetailsGrid extends StatelessWidget {
  final Property property;

  const DetailsGrid({required this.property});

  @override
  Widget build(BuildContext context) {
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 3.6,
      ),
      children: [
        _DetailItem("Bedrooms", "${property.bedrooms}"),
        _DetailItem("Bathrooms", "${property.bathrooms}"),
        _DetailItem("Area", "${property.areaSqft} sqft"),
        _DetailItem("Build Year", "${property.buildYear}"),
        _DetailItem("Parking", property.parking ? "Available" : "No"),
        _DetailItem("Status", property.status),
      ],
    );
  }
}

class _DetailItem extends StatelessWidget {
  final String label;
  final String value;

  const _DetailItem(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "$label: ",
          style: const TextStyle(fontWeight: FontWeight.w600 , color: SAppColors.secondaryDarkBlue),
        ),
        Text(value),
      ],
    );
  }
}
