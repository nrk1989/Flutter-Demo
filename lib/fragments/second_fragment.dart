import 'package:flutter/material.dart';
import 'package:page_indicator/page_indicator.dart';

class PageViewDemo extends StatefulWidget {
  @override
  _PageViewDemoState createState() => _PageViewDemoState();
}

class _PageViewDemoState extends State<PageViewDemo> {
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  PageController _controller = PageController(
    initialPage: 0,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new PageIndicatorContainer(
        length: 3,
        indicatorSpace: 20.0,
        padding: const EdgeInsets.all(20),
        indicatorColor: Colors.white,
        indicatorSelectorColor: Colors.green,
        shape: IndicatorShape.circle(size: 12),
        child: PageView(
          controller: _controller,
          children: [
            buildPage('Text1'),
            buildPage('Text2'),
            buildPage('Text3')
          ],
        ));
  }

  Widget buildPage(String text) {
    return Container(
      child: Center(child: Text(text, style: optionStyle)),
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black45, width: 5),
        color: Colors.pinkAccent,
      ),
    );
  }
}
