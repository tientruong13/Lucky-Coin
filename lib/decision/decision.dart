import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucky_coin_flip/button.dart';

import 'package:lucky_coin_flip/decision/ResultSavedPage.dart';
import 'package:lucky_coin_flip/decision/CoinFlipForDecision.dart';
import 'package:lucky_coin_flip/utils/navigateWithFade.dart';
import 'package:lucky_coin_flip/main.dart';
import 'package:lucky_coin_flip/utils/size.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

class FateCoinPage extends StatefulWidget {
  @override
  State<FateCoinPage> createState() => _FateCoinPageState();
}

class _FateCoinPageState extends State<FateCoinPage> with RouteAware {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String? pickedSide;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void didPopNext() {
    _focusNode.unfocus();
    pickedSide = null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Padding(
        padding: EdgeInsets.only(left: 5.w, right: 5.w),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
                  padding: EdgeInsets.only(left: 80.w),
                  child: GestureDetector(
                    onTap: () {
                      navigateWithFade(context, ResultSavedPage());
                    },
                    child: Image.asset(
                      'assets/images/list.png',
                      width: 9.w,
                      height: 9.w,
                    ),
                  ),
                )
                .animate(delay: 100.ms + 150.ms)
                .moveX(
                  begin: responsiveDoule(context, [20.w, 20.w]),
                  end: 0,
                  curve: Curves.fastOutSlowIn,
                  duration: 1200.ms,
                ),
            SizedBox(height: 8.h),
            Text(
                  "What are you flipping for?",
                  style: TextStyle(fontSize: 20.sp, color: Colors.white70),
                )
                .animate(delay: 100.ms + (2 * 150).ms)
                .moveX(
                  begin: responsiveDoule(context, [90.w, 80.w]),
                  end: 0,
                  curve: Curves.fastOutSlowIn,
                  duration: 1200.ms,
                ),
            SizedBox(height: 4.h),
            Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: responsiveDoule(context, [2.w, 4.w]),
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFF073F3F),
                    borderRadius: BorderRadius.circular(3.w),
                  ),
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    style: TextStyle(fontSize: 20.sp, color: Colors.white70),
                    maxLines: 2,

                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Enter your reason here...",
                      hintStyle: TextStyle(
                        color: Colors.white70,
                        fontSize: responsiveDoule(context, [18.sp, 20.sp]),
                      ),
                    ),
                  ),
                )
                .animate(delay: 100.ms + (3 * 150).ms)
                .moveX(
                  begin: responsiveDoule(context, [100.w, 95.w]),
                  end: 0,
                  curve: Curves.fastOutSlowIn,
                  duration: 1200.ms,
                ),
            SizedBox(height: 4.h),
            Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildPickButton("Heads"),
                    SizedBox(width: 4.w),
                    _buildPickButton("Tails"),
                  ],
                )
                .animate(delay: 100.ms + (4 * 150).ms)
                .moveX(
                  begin: responsiveDoule(context, [100.w, 90.w]),
                  end: 0,
                  curve: Curves.fastOutSlowIn,
                  duration: 1200.ms,
                ),

            SizedBox(height: 4.h),

            FlipButton(
                  decision: true,
                  controller: true,
                  onTap: () {
                    if (_controller.text.trim().isEmpty || pickedSide == null)
                      return;

                    FocusManager.instance.primaryFocus?.unfocus();
                    navigateWithFade(
                      context,
                      FlipCoinForDesicion(
                        reason: _controller.text.trim(),
                        pickedSide: pickedSide!,
                        // autoFlip: true
                      ),
                    );
                    _controller.clear();
                  },
                )
                .animate(delay: 100.ms + (5 * 150).ms)
                .moveX(
                  begin: responsiveDoule(context, [100.w, 90.w]),
                  end: 0,
                  curve: Curves.fastOutSlowIn,
                  duration: 1200.ms,
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildPickButton(String label) {
    final isSelected = pickedSide == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          pickedSide = label;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 250),
        height: 5.h,
        width: 30.w,
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF073F3F) : Colors.transparent,
          border: Border.all(
            color: isSelected ? Color(0xFF073F3F) : Colors.white54,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(4.w),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white70,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
