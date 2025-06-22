import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucky_coin_flip/button.dart';
import 'package:lucky_coin_flip/utils/size.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CoinFlip extends StatefulWidget {
  CoinFlip({super.key, this.autoFlip = false, this.onFlipComplete});

  final bool autoFlip;
  final void Function(bool isHeads, bool showResultText)? onFlipComplete;

  @override
  _CoinFlipState createState() => _CoinFlipState();
}

class _CoinFlipState extends State<CoinFlip>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnim;
  late Animation<double> _jumpAnim;
  bool showResultText = false;
  bool isHeads = true;
  bool showSavedText = false;

  final AudioPlayer tingPlayer = AudioPlayer();
  final AudioPlayer successPlayer = AudioPlayer();

  double lastPlayedAngle = 0;
  double endAngle = 0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(milliseconds: 2500),
      vsync: this,
    );

    _rotationAnim = AlwaysStoppedAnimation(0);

    _jumpAnim = Tween<double>(
      begin: 0,
      end: -25.h,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutQuad));

    _controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        final angleAtEnd = endAngle % (2 * pi);
        final front = angleAtEnd <= pi / 2 || angleAtEnd >= 3 * pi / 2;

        setState(() {
          isHeads = front;
          showResultText = true;
        });

        HapticFeedback.mediumImpact();
        await successPlayer.play(
          AssetSource('sounds/success.mp3'),
          volume: 1.0,
        );
      }
    });

    if (widget.autoFlip) {
      Future.delayed(Duration(milliseconds: 500), () {
        setState(() {
          _flipCoin();
        });
      });
    }
  }

  void _flipCoin() {
    final rand = Random();
    final fullSpins = rand.nextInt(5) + 15;
    final isHeadsResult = rand.nextBool();
    final offset = isHeadsResult ? 0 : pi;

    endAngle = fullSpins * 2 * pi + offset;
    lastPlayedAngle = 0;

    _rotationAnim = Tween<double>(begin: 0, end: endAngle).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutQuart),
    )..addListener(() {
      double currentAngle = _rotationAnim.value;
      if ((currentAngle - lastPlayedAngle) >= pi) {
        tingPlayer.play(AssetSource('sounds/ting.mp3'), volume: 0.8);
        lastPlayedAngle = currentAngle;
      }
    });

    _controller.forward(from: 0).whenComplete(() {
      HapticFeedback.mediumImpact();
      successPlayer.play(AssetSource('sounds/success.mp3'), volume: 1.0);

      setState(() {
        isHeads = isHeadsResult;
        showResultText = true;
      });
      widget.onFlipComplete?.call(isHeadsResult, true);
    });
  }

  Widget _buildCoin(double angle, double verticalOffset) {
    final value = angle % (2 * pi);
    final isFront = value <= pi / 2 || value >= 3 * pi / 2;
    final imagePath =
        isFront ? 'assets/images/Heads.png' : 'assets/images/Tails.png';
    final coinImage = Image.asset(imagePath, fit: BoxFit.cover);

    final flippedImage =
        !isFront
            ? Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(pi),
              child: coinImage,
            )
            : coinImage;

    return Transform.translate(
      offset: Offset(0, verticalOffset),
      child: Transform(
        alignment: Alignment.center,
        transform:
            Matrix4.identity()
              ..setEntry(3, 2, 0.002)
              ..rotateY(angle),
        child: Container(
          width: responsiveDoule(context, [50.w, 40.w]),
          height: responsiveDoule(context, [50.w, 40.w]),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                offset: Offset(0, 4),
                blurRadius: 8,
              ),
            ],
          ),
          child: ClipOval(child: flippedImage),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    tingPlayer.dispose();
    successPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget coin = AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return _buildCoin(
          _rotationAnim.value,
          _jumpAnim.value * sin(_controller.value * pi),
        );
      },
    );

    if (!widget.autoFlip) {
      coin = coin
          .animate(delay: 250.ms)
          .moveX(
            begin: responsiveDoule(context, [-75.w, -70.w]),
            end: 0,
            curve: Curves.fastOutSlowIn,
            duration: 1000.ms,
          );
    }

    return SizedBox(
      child: Column(
        children: [
          coin,
          SizedBox(height: 10.h),
          if (!widget.autoFlip)
            FlipButton(
                  decision: false,
                  controller: _controller.isAnimating,
                  onTap: () {
                    setState(() {
                      showResultText = false;
                      _controller.reset();
                      _flipCoin();
                    });
                  },
                )
                .animate(delay: 100.ms + (2 * 150).ms)
                .moveX(
                  begin: responsiveDoule(context, [-80.w, -75.w]),
                  end: 0,
                  curve: Curves.fastOutSlowIn,
                  duration: 1000.ms,
                ),
        ],
      ),
    );
  }
}
