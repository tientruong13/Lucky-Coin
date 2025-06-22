import 'dart:ui';

import 'package:flutter/material.dart';

class background extends StatelessWidget {
  const background({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF073F3F), Color(0xFF012E2E), Color(0xFF000A14)],
            ),
          ),
        ),

        Container(color: Colors.black.withOpacity(0.1)),
      ],
    );
  }
}
