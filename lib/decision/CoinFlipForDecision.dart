import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucky_coin_flip/background.dart';
import 'package:lucky_coin_flip/decision/bloc/flip_result_bloc.dart';
import 'package:lucky_coin_flip/decision/bloc/flip_result_event.dart';
import 'package:lucky_coin_flip/quick/CoinFlipPage.dart';
import 'package:lucky_coin_flip/utils/IconButton.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class FlipCoinForDesicion extends StatefulWidget {
  const FlipCoinForDesicion({
    super.key,
    required this.reason,
    required this.pickedSide,
  });
  final String reason;
  final String pickedSide;

  @override
  State<FlipCoinForDesicion> createState() => _FlipCoinForDesicionState();
}

class _FlipCoinForDesicionState extends State<FlipCoinForDesicion> {
  bool? isHeads;
  bool showResult = false;
  bool showSavedText = false;
  bool hasSaved = false;
  String getFlipMessage(bool isHeads, String pickedSide) {
    final resultSide = isHeads ? "Heads" : "Tails";
    if (pickedSide == resultSide) {
      return "You nailed it. Destiny agrees!";
    } else {
      return "$pickedSide picked, but destiny flipped.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        background(),

        Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Positioned(
                top: 10.h,
                left: 0,
                right: 0,
                child: AnimatedOpacity(
                  opacity: showSavedText ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFF012E2E),
                        borderRadius: BorderRadius.circular(3.w),
                      ),
                      child: Text(
                        'Result saved',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 3.w, right: 5.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.arrow_back_ios_new,
                                color: Colors.white70,
                              ),
                            ),
                            Iconbutton(
                              path: 'assets/images/saved.png',
                              onTap: () {
                                if (hasSaved) return;

                                context.read<FlipResultBloc>().add(
                                  SaveFlipResultEvent(
                                    reason: widget.reason,
                                    picked: widget.pickedSide,
                                    result: isHeads == true ? "Heads" : "Tails",
                                    timestamp: DateTime.now(),
                                  ),
                                );

                                setState(() {
                                  showSavedText = true;
                                  hasSaved = true;
                                });

                                Future.delayed(Duration(seconds: 3), () {
                                  if (mounted) {
                                    setState(() => showSavedText = false);
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 25.h),
                      CoinFlip(
                        autoFlip: true,
                        onFlipComplete: (result, done) {
                          setState(() {
                            isHeads = result;
                            showResult = done;
                          });

                          print("🪙 Kết quả: ${result ? "Heads" : "Tails"}");
                        },
                      ),
                      if (showResult && isHeads != null)
                        Padding(
                          padding: EdgeInsets.only(top: 4.h),
                          child: Text(
                            getFlipMessage(isHeads!, widget.pickedSide),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
