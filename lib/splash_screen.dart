import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucky_coin_flip/homepage.dart';
import 'package:lucky_coin_flip/utils/navigateWithFade.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _exitController;
  late Animation<double> _rotationAnim;
  late Animation<double> _jumpAnim;
  late Animation<Offset> _moveOutAnim;
  late Animation<double> _fadeOutAnim;

  bool isHeads = true;
  double lastPlayedAngle = 0;
  double endAngle = 0;

  final AudioPlayer tingPlayer = AudioPlayer();
  final AudioPlayer successPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();

    // Animation quay đồng xu
    _controller = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );

    _rotationAnim = AlwaysStoppedAnimation(0);
    _jumpAnim = Tween<double>(
      begin: 0,
      end: -25.h,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutQuad));

    // Animation bay ra + mờ dần
    _exitController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );

    _moveOutAnim = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(2.0, 0), // 👈 sang phải
    ).animate(
      CurvedAnimation(parent: _exitController, curve: Curves.easeInOut),
    );

    _fadeOutAnim = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _exitController, curve: Curves.easeInOut),
    );

    // Khi quay xong, xác định mặt và trigger exit
    _controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        final angleAtEnd = endAngle % (2 * pi);
        final front = angleAtEnd <= pi / 2 || angleAtEnd >= 3 * pi / 2;

        setState(() {
          isHeads = front;
        });
        await Future.delayed(Duration(seconds: 1));

        // Start exit + navigate
        _exitController.forward().whenComplete(() {
          navigateWithFade(context, const HomePage());
        });
      }
    });

    // Delay rồi bắt đầu quay
    Future.delayed(Duration(milliseconds: 100), _flipCoin);
  }

  void _flipCoin() {
    final rand = Random();
    final fullSpins = rand.nextInt(5) + 10;
    final isHeadsResult = rand.nextBool();
    final deviation = rand.nextDouble() * (pi / 8);
    final offset = isHeadsResult ? deviation : pi + deviation;

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

    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    _exitController.dispose();
    tingPlayer.dispose();
    successPlayer.dispose();
    super.dispose();
  }

  Widget _buildCoin(double angle, double verticalOffset) {
    final value = angle % (2 * pi);
    final isFront = value <= pi / 2 || value >= 3 * pi / 2;
    final imagePath =
        isFront ? 'assets/images/Heads.png' : 'assets/images/Tails.png';

    final coinImage = Image.asset(imagePath, fit: BoxFit.cover);
    final flippedImage =
        isFront
            ? coinImage
            : Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(pi),
              child: coinImage,
            );

    return Transform.translate(
      offset: Offset(0, verticalOffset),
      child: Transform(
        alignment: Alignment.center,
        transform:
            Matrix4.identity()
              ..setEntry(3, 2, 0.002)
              ..rotateY(angle),
        child: Container(
          width: 15.w,
          height: 15.w,
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF012E2E),
      body: SafeArea(
        child: Center(
          child: FadeTransition(
            opacity: _fadeOutAnim,
            child: SlideTransition(
              position: _moveOutAnim,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (_, __) {
                      return _buildCoin(
                        _rotationAnim.value,
                        _jumpAnim.value * sin(_controller.value * pi),
                      );
                    },
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "Lucky Coin",
                    style: TextStyle(
                      fontSize: 25.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
