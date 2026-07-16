import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_do_list/core/constants/class_images.dart';
import 'package:to_do_list/screens/splash/splash_controller.dart';

/// Animated splash screen.
///
/// Kept as a StatefulWidget (instead of GetView) so it can drive its own
/// AnimationController, while still looking up SplashController via
/// Get.find so navigation logic in the controller is untouched.
class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  // Ensures the controller (and its navigation timer) is initialized,
  // matching the previous GetView<SplashController> behavior.
  final SplashController controller = Get.find<SplashController>();

  late final AnimationController _animationController;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _contentOpacity;
  late final Animation<Offset> _contentSlide;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _logoScale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.65, curve: Curves.easeOutBack),
      ),
    );

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _contentOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
      ),
    );

    _contentSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
          ),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Color(0xFFF1F4FD)],
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, _) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Opacity(
                    opacity: _logoOpacity.value,
                    child: Transform.scale(
                      scale: _logoScale.value,
                      child: Image.asset(
                        AppImage.logo,
                        width: 270,
                        height: 270,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  // const SizedBox(height: 28),
                  // SlideTransition(
                  //   position: _contentSlide,
                  //   child: FadeTransition(
                  //     opacity: _contentOpacity,
                  //     child: Column(
                  //       children: [
                  //         Text(
                  //           'To Do List',
                  //           style: TextStyle(
                  //             fontSize: 26,
                  //             fontWeight: FontWeight.bold,
                  //             color: Colors.blueGrey.shade800,
                  //             letterSpacing: 0.5,
                  //           ),
                  //         ),
                  //         const SizedBox(height: 6),
                  //         Text(
                  //           'Stay organized, stay ahead',
                  //           style: TextStyle(
                  //             fontSize: 13,
                  //             color: Colors.blueGrey.shade400,
                  //             letterSpacing: 0.3,
                  //           ),
                  //         ),
                  //         const SizedBox(height: 36),
                  //         SizedBox(
                  //           width: 26,
                  //           height: 26,
                  //           child: CircularProgressIndicator(
                  //             strokeWidth: 2.5,
                  //             valueColor: AlwaysStoppedAnimation<Color>(
                  //               Colors.blueGrey.shade300,
                  //             ),
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
