import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _particleController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<double> _particleAnimation;

  @override
  void initState() {
    super.initState();

    // 🎬 Main animation controller (sama seperti sebelumnya)
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    // 🌀 Particle/orbit animation controller
    _particleController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4),
    )..repeat();

    // 🔍 Scale animation (sama)
    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    // 🌫️ Fade animation (sama)
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    // 🔄 Subtle ring rotation
    _rotateAnimation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _particleController, curve: Curves.linear),
    );

    // ✨ Particle pulse
    _particleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _particleController, curve: Curves.easeInOut),
    );

    // ▶️ Mulai animasi (sama)
    _controller.forward();

    // ⏳ Delay → pindah ke login (sama)
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0F1B2D), Color(0xFF1A2E4A), Color(0xFF0D2137)],
          ),
        ),
        child: Stack(
          children: [
            // 🌐 Background decorative circles
            _buildBackgroundDecor(),

            // 🎯 Main content
            Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 🔵 Animated logo container
                      _buildLogoSection(),
                      SizedBox(height: 36),

                      // 📝 App title
                      _buildTitleSection(),
                      SizedBox(height: 12),

                      // 💬 Subtitle
                      _buildSubtitle(),
                    ],
                  ),
                ),
              ),
            ),

            // 🔻 Bottom loading bar
            _buildBottomIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundDecor() {
    return AnimatedBuilder(
      animation: _particleController,
      builder: (context, child) {
        return Stack(
          children: [
            // Top-left glow
            Positioned(
              top: -80,
              left: -60,
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Color(0xFF1565C0).withOpacity(0.25),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            // Bottom-right glow
            Positioned(
              bottom: -100,
              right: -70,
              child: Container(
                width: 320,
                height: 320,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Color(0xFF0288D1).withOpacity(0.2),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLogoSection() {
    return AnimatedBuilder(
      animation: _particleController,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // 🌀 Outer rotating dashed ring
            Transform.rotate(
              angle: _rotateAnimation.value,
              child: CustomPaint(
                size: Size(160, 160),
                painter: _DashedRingPainter(
                  color: Color(0xFF42A5F5).withOpacity(0.4),
                  strokeWidth: 1.5,
                  dashCount: 24,
                ),
              ),
            ),
            // 🔵 Inner slow counter-rotate ring
            Transform.rotate(
              angle: -_rotateAnimation.value * 0.5,
              child: CustomPaint(
                size: Size(120, 120),
                painter: _DashedRingPainter(
                  color: Color(0xFF64B5F6).withOpacity(0.25),
                  strokeWidth: 1.0,
                  dashCount: 16,
                ),
              ),
            ),
            // 💎 Logo box
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF1565C0),
                    Color(0xFF0288D1),
                    Color(0xFF0097A7),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF1565C0).withOpacity(0.5),
                    blurRadius: 30,
                    spreadRadius: 4,
                  ),
                  BoxShadow(
                    color: Color(0xFF0288D1).withOpacity(0.3),
                    blurRadius: 60,
                    spreadRadius: 8,
                  ),
                ],
              ),
              child: Icon(Icons.school_rounded, size: 44, color: Colors.white),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTitleSection() {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [Color(0xFF90CAF9), Color(0xFFFFFFFF), Color(0xFF81D4FA)],
          ).createShader(bounds),
          child: Text(
            "MAHASISWA",
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w900,
              letterSpacing: 8,
            ),
          ),
        ),
        SizedBox(height: 4),
        Text(
          "A P P",
          style: TextStyle(
            color: Color(0xFF42A5F5).withOpacity(0.8),
            fontSize: 13,
            fontWeight: FontWeight.w400,
            letterSpacing: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildSubtitle() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFF42A5F5).withOpacity(0.2)),
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.04),
      ),
      child: Text(
        "Manajemen Data Mahasiswa",
        style: TextStyle(
          color: Color(0xFF90CAF9).withOpacity(0.8),
          fontSize: 12,
          letterSpacing: 1.5,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }

  Widget _buildBottomIndicator() {
    return Positioned(
      bottom: 48,
      left: 0,
      right: 0,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            AnimatedBuilder(
              animation: _particleController,
              builder: (context, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (i) {
                    double offset = ((_particleAnimation.value + i / 3) % 1.0);
                    double size = 6 + (math.sin(offset * math.pi) * 4);
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      width: size,
                      height: size,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(
                          0xFF42A5F5,
                        ).withOpacity(0.4 + math.sin(offset * math.pi) * 0.6),
                      ),
                    );
                  }),
                );
              },
            ),
            SizedBox(height: 12),
            Text(
              "Firebase · Flutter · Firestore",
              style: TextStyle(
                color: Colors.white.withOpacity(0.2),
                fontSize: 10,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 🖌️ Custom painter untuk dashed ring
class _DashedRingPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final int dashCount;

  _DashedRingPainter({
    required this.color,
    required this.strokeWidth,
    required this.dashCount,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final dashAngle = (2 * math.pi) / dashCount;
    final gapRatio = 0.4;

    for (int i = 0; i < dashCount; i++) {
      final startAngle = dashAngle * i;
      final sweepAngle = dashAngle * (1 - gapRatio);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
