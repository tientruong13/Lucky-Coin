import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lucky_coin_flip/background.dart';
import 'package:lucky_coin_flip/decision/bloc/flip_result_bloc.dart';
import 'package:lucky_coin_flip/decision/bloc/flip_result_event.dart';
import 'package:lucky_coin_flip/decision/bloc/flip_result_state.dart';
import 'package:lucky_coin_flip/decision/model/flip_result_model.dart';
import 'package:lucky_coin_flip/utils/IconButton.dart';
import 'package:lucky_coin_flip/utils/size.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ResultSavedPage extends StatelessWidget {
  const ResultSavedPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Gửi event load dữ liệu khi mở trang
    context.read<FlipResultBloc>().add(LoadFlipResultsEvent());

    return Stack(
      children: [
        background(),
        Scaffold(
          backgroundColor: Colors.transparent,

          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 3.w, right: 5.w, bottom: 1.h),
                  child: SizedBox(
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
                            Text(
                              'Saved Results',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white70,
                              ),
                            ),
                            Iconbutton(
                              path: "assets/images/delete.png",
                              onTap: () {
                                final bloc = context.read<FlipResultBloc>();

                                showDialog(
                                  context: context,
                                  builder:
                                      (context) => AlertDialog(
                                        backgroundColor: const Color(
                                          0xFF1B263B,
                                        ),
                                        title: const Text(
                                          "Clear all results?",
                                          style: TextStyle(
                                            color: Colors.white70,
                                          ),
                                        ),
                                        content: const Text(
                                          "This will delete all saved flips permanently.",
                                          style: TextStyle(
                                            color: Colors.white70,
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed:
                                                () => Navigator.pop(context),
                                            child: const Text(
                                              "Cancel",
                                              style: TextStyle(
                                                color: Colors.white54,
                                              ),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              bloc.add(ClearAllResultsEvent());
                                              Navigator.pop(context);
                                            },
                                            child: const Text(
                                              "Delete",
                                              style: TextStyle(
                                                color: Colors.redAccent,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                );
                              },
                            ),
                          ],
                        ),
                      )
                      .animate(delay: Duration(milliseconds: 300))
                      .fade(
                        begin: 0,
                        end: 1,
                        curve: Curves.easeInOut,
                        duration: Duration(milliseconds: 500),
                      )
                      .scale(
                        begin: Offset(5, 5),
                        end: Offset(1, 1),
                        curve: Curves.easeInOut,
                        duration: Duration(milliseconds: 500),
                      ),
                ),
                Expanded(
                  child: BlocBuilder<FlipResultBloc, FlipResultState>(
                    builder: (context, state) {
                      if (state is FlipResultLoaded) {
                        if (state.results.isEmpty) {
                          return Center(
                            child: Text(
                              'No results yet.',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16.sp,
                              ),
                            ),
                          );
                        }

                        return ListView.builder(
                          padding: EdgeInsets.symmetric(
                            horizontal: 4.w,
                            vertical: 2.h,
                          ),
                          itemCount: state.results.length,
                          itemBuilder: (context, index) {
                            final FlipResultModel item = state.results[index];
                            final dateFormatted = DateFormat(
                              'MMM dd, yyyy – hh:mm a',
                            ).format(item.timestamp);

                            final key = item.key as int;

                            return Stack(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(bottom: 2.h),
                                      padding: EdgeInsets.all(2.w),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF1B263B),
                                        borderRadius: BorderRadius.circular(
                                          3.w,
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.reason,
                                            style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 17.sp,
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Picked: ${item.picked}',
                                                style: TextStyle(
                                                  color: Colors.greenAccent,
                                                  fontSize: 15.sp,
                                                ),
                                              ),
                                              Text(
                                                'Result: ${item.result}',
                                                style: TextStyle(
                                                  color: Colors.redAccent,
                                                  fontSize: 15.sp,
                                                ),
                                              ),
                                              Text(
                                                dateFormatted,
                                                style: TextStyle(
                                                  color: Colors.white54,
                                                  fontSize: 13.sp,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      top: 1.h,
                                      right: 2.w,
                                      child: GestureDetector(
                                        onTap: () {
                                          context.read<FlipResultBloc>().add(
                                            DeleteFlipResultEvent(key),
                                          );
                                        },
                                        child: Image.asset(
                                          "assets/images/delete1.png",
                                          width: responsiveDoule(context, [
                                            5.w,
                                            3.w,
                                          ]),
                                          height: responsiveDoule(context, [
                                            5.w,
                                            3.w,
                                          ]),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                                .animate(
                                  delay: Duration(
                                    milliseconds: 700 + index * 100,
                                  ),
                                )
                                .fadeIn(
                                  duration: Duration(milliseconds: 600),
                                  curve: Curves.fastOutSlowIn,
                                )
                                .slideY(
                                  begin: 0.2,
                                  end: 0,
                                  duration: Duration(milliseconds: 600),
                                  curve: Curves.fastOutSlowIn,
                                );
                          },
                        );
                      }

                      return const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
