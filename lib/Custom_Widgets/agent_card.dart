import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Models/property_model.dart';
import '../Theme/app_colors.dart';

class AgentCard extends StatelessWidget {
  final Agent agent;

  const AgentCard({required this.agent});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              agent.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              agent.role,
              style: const TextStyle(color: SAppColors.descriptionTextGray),
            ),
          ],
        )
      ],
    );
  }
}
