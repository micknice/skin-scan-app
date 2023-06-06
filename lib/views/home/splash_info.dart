import 'package:fancy_text_reveal/fancy_text_reveal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:skin_scan_app/animations/animation_vars.dart';
import 'package:skin_scan_app/constants/routes.dart';

class SplashInfo extends StatelessWidget {
  const SplashInfo({super.key});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(
                      "https://images.unsplash.com/photo-1541694458248-5aa2101c77df?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=687&q=80"),
                  fit: BoxFit.fitHeight)),
        ),
        Center(
            child: Align(
          alignment: const Alignment(0.0, -0.8),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const FancyTextReveal(
                properties: Properties(
                    milliseconds: textRevealDurationMs,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        backgroundBlendMode: BlendMode.srcIn)),
                child: Text(
                  'Get informed',
                  style: TextStyle(
                      fontSize: 60.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                )),
          )
              .animate()
              .slideX(
                  delay: const Duration(
                    milliseconds: slideDelayDurationMs,
                  ),
                  begin: -1.0,
                  curve: Curves.easeInCubic)
              .fadeIn(
                  duration: const Duration(milliseconds: fadeInDurationMs),
                  curve: Curves.easeIn),
        )),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Center(
                child: Align(
              alignment: const Alignment(1, -0.48),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const FancyTextReveal(
                    properties: Properties(
                      milliseconds: textRevealDurationMs,
                    ),
                    child: Text(
                      'about',
                      style: TextStyle(
                          fontSize: 60.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    )),
              )
                  .animate()
                  .slideX(
                      delay: const Duration(
                        milliseconds: slideDelayDurationMs,
                      ),
                      begin: 1.0,
                      curve: Curves.easeInCubic)
                  .fadeIn(
                      duration: const Duration(milliseconds: fadeInDurationMs),
                      curve: Curves.easeIn),
            )),
            Center(
                child: Align(
              alignment: const Alignment(-1.0, 0.69),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const FancyTextReveal(
                    properties: Properties(
                      milliseconds: textRevealDurationMs,
                    ),
                    child: Text(
                      'skin cancer',
                      style: TextStyle(
                          fontSize: 60.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    )),
              )
                  .animate()
                  .slideX(
                      delay: const Duration(
                        milliseconds: slideDelayDurationMs,
                      ),
                      begin: 1.8,
                      curve: Curves.easeInCubic)
                  .fadeIn(
                      duration: const Duration(milliseconds: fadeInDurationMs),
                      curve: Curves.easeIn),
            )),
            const SizedBox(
              height: 30,
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(infoViewRoute);
                  },
                  child: const Align(
                    alignment: Alignment(0, 0.5),
                    child: Text(
                      'Learn more',
                      style: TextStyle(
                          fontSize: 25.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
