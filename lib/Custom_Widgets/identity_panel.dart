import 'package:flutter/cupertino.dart';

import '../Models/user_model.dart';
import '../Models/user_verification_model.dart';
import 'id_card.dart';

class IdentityPanel extends StatelessWidget {
  final UserVerificationModel user;

  const IdentityPanel({required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Identity Verification",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 24),

        Row(
          children: [
            IdCard(title: "ID Front", imageUrl: user.idPhotoFront),
            const SizedBox(width: 24),
            IdCard(title: "ID Back", imageUrl: user.idPhotoBack),
          ],
        ),
      ],
    );
  }
}
