import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lucky_coin_flip/utils/size.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class FlipButton extends StatefulWidget {
  const FlipButton({
    super.key,
    this.onTap,
    required this.controller,
    required this.decision,
  });
  final VoidCallback? onTap;
  final bool controller;
  final bool decision;

  @override
  State<FlipButton> createState() => _FlipButtonState();
}

class _FlipButtonState extends State<FlipButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      lowerBound: 0.5,
      upperBound: 1.0,
    );

    _scaleAnim = _controller.drive(CurveTween(curve: Curves.easeOut));

    _controller.value = 1.0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() async {
    await _controller.reverse();
    await _controller.forward();
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          widget.decision
              ? _handleTap
              : widget.controller
              ? null
              : _handleTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: responsiveDoule(context, [25.w, 20.w]),
            height: responsiveDoule(context, [25.w, 20.w]),
            decoration: BoxDecoration(
              color: Color(0xFF073F3F).withOpacity(0.5),
              borderRadius: BorderRadius.circular(20.w),
            ),

            child: Center(
              child: Container(
                height: responsiveDoule(context, [15.w, 10.w]),
                width: responsiveDoule(context, [15.w, 10.w]),
                decoration: BoxDecoration(
                  color: Colors.white10.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20.w),
                ),
              ),
            ),
          ),
          ScaleTransition(
            scale: _scaleAnim,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.w),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                child: Container(
                  width: responsiveDoule(context, [20.w, 15.w]),
                  height: responsiveDoule(context, [20.w, 15.w]),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(10.w),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/images/flip.png',
                      width: responsiveDoule(context, [15.w, 10.w]),
                      height: responsiveDoule(context, [15.w, 10.w]),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PowerButton extends StatelessWidget {
  final VoidCallback onPressed;

  const PowerButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 30.w,
            height: 30.w,
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.5),
              borderRadius: BorderRadius.circular(20.w),
            ),
            child: Center(
              child: Container(
                width: 25.w,
                height: 25.w,
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20.w),
                ),

                child: Center(
                  child: Container(
                    height: 15.w,
                    width: 15.w,
                    decoration: BoxDecoration(
                      color: Colors.white10.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20.w),
                    ),
                  ),
                ),
              ),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(10.w),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              child: Container(
                width: 20.w,
                height: 20.w,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(10.w),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: Image.asset(
                    'assets/images/flip.png',
                    width: 15.w,
                    height: 15.w,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
