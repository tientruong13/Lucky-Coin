import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucky_coin_flip/background.dart';
import 'package:lucky_coin_flip/bottombar.dart';
import 'package:lucky_coin_flip/decision/decision.dart';
import 'package:lucky_coin_flip/quick/CoinFlipPage.dart';
import 'package:lucky_coin_flip/utils/size.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isQuickFlipSelected = true;
  bool forceReverse = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          isQuickFlipSelected ? null : () => FocusScope.of(context).unfocus(),
      child: Stack(
        children: [
          background(),
          Scaffold(
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: false,

            body: SafeArea(
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: isQuickFlipSelected ? 22.h : 0.h),

                      Expanded(
                        child: Center(
                          child:
                              isQuickFlipSelected ? CoinFlip() : FateCoinPage(),
                        ),
                      ),
                      SizedBox(height: 5.h),
                      BottomBar(
                            isQuick: isQuickFlipSelected,

                            onTap: (isQuick) {
                              setState(() {
                                isQuickFlipSelected = isQuick;
                              });
                            },
                          )
                          .animate(delay: 100.ms + (3 * 150).ms)
                          .moveX(
                            begin: responsiveDoule(context, [-90.w, -90.w]),

                            end: 0,
                            curve: Curves.fastOutSlowIn,
                            duration: 1000.ms,
                          ),
                      SizedBox(height: 1.h),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
