import 'package:fancy_text_reveal/fancy_text_reveal.dart';
import 'package:flutter/material.dart';
import 'package:skin_scan_app/constants/routes.dart';

class SplashAssess extends StatelessWidget {
  const SplashAssess({super.key});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(
                      "https://images.unsplash.com/photo-1489980721706-f487dab89c24?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1171&q=80url"),
                  fit: BoxFit.fitHeight)),
        ),
        const Center(
            child: Align(
          alignment: Alignment(1, -0.8),
          child: DecoratedBox(
            decoration: BoxDecoration(color: Colors.white),
            child: FancyTextReveal(
                properties: Properties(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        backgroundBlendMode: BlendMode.srcIn)),
                child: Text(
                  'Skin Scan',
                  style: TextStyle(
                      fontSize: 60.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                )),
          ),
        )),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
             Center(
                child: Align(
              alignment: Alignment(-1, -0.48),
              child: DecoratedBox(
                decoration:  BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10.0),),
                child: FancyTextReveal(
                    child: Text(
                  'Summer',
                  style: TextStyle(
                      fontSize: 60.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                )),
              ),
            )),
            const Center(
                child: Align(
              alignment: Alignment(0.3, 0.69),
              child: DecoratedBox(
                decoration: const BoxDecoration(color: Colors.white),
                child: FancyTextReveal(
                    child: Text(
                  'is here!',
                  style: TextStyle(
                      fontSize: 60.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                )),
              ),
            )),
            const SizedBox(
              height: 30,
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(cameraViewRoute);
                  },
                  child: const Align(
                    alignment: Alignment(0, 0.5),
                    child: Text(
                      'Get assessed now',
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
