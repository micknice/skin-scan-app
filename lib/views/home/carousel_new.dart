import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:skin_scan_app/views/home/splash_assess.dart';
import 'package:skin_scan_app/views/home/splash_info.dart';
import 'package:skin_scan_app/views/home/splash_support.dart';

List<StatelessWidget> splashList = [
  const SplashAssess(),
  const SplashInfo(),
  const SplashSupport(),
];

class ManuallyControlledSlider extends StatefulWidget {
  const ManuallyControlledSlider({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ManuallyControlledSliderState();
  }
}

class _ManuallyControlledSliderState extends State<ManuallyControlledSlider> {
  final CarouselController _controller = CarouselController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Builder(builder: (context) {
      final double height = MediaQuery.of(context).size.height;
      return Stack(
        children: <Widget>[
          CarouselSlider(
            items: splashList.map((item) => Container(child: item)).toList(),
            options: CarouselOptions(
                viewportFraction: 1.0,
                enlargeCenterPage: false,
                height: height,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 6)),
            carouselController: _controller,
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: IconButton(
                      onPressed: () => _controller.previousPage(),
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      )),
                ),
                Flexible(
                  child: IconButton(
                    onPressed: () => _controller.nextPage(),
                    icon: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      );
    }));
  }
}
