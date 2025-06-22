import 'package:flutter/cupertino.dart';
import 'package:lucky_coin_flip/utils/size.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class Iconbutton extends StatelessWidget {
  const Iconbutton({super.key, required this.path, this.onTap});
  final String path;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(
        path,
        width: responsiveDoule(context, [9.w, 7.w]),
        height: responsiveDoule(context, [9.w, 7.w]),
      ),
    );
  }
}
