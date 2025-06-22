import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lucky_coin_flip/utils/size.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class BottomBar extends StatelessWidget {
  final bool isQuick;
  final ValueChanged<bool> onTap;

  const BottomBar({super.key, required this.isQuick, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: responsiveDoule(context, [80.w, 70.w]),
      height: 8.h,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10.w),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () => onTap(true),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedScale(
                  scale: isQuick ? 1.3 : 1.0,
                  duration: Duration(milliseconds: 200),
                  child: Text(
                    'Quick Flip',
                    style: TextStyle(
                      color:
                          isQuick
                              ? Color.fromARGB(255, 23, 233, 233)
                              : Colors.white60,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => onTap(false),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedScale(
                  scale: !isQuick ? 1.3 : 1.0,
                  duration: Duration(milliseconds: 200),
                  child: Text(
                    'Decision Flip',
                    style: TextStyle(
                      color:
                          !isQuick
                              ? Color.fromARGB(255, 23, 233, 233)
                              : Colors.white60,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
