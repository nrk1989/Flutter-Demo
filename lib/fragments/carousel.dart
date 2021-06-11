import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:infinite_carousel/infinite_carousel.dart';
import 'dart:convert';
import 'dart:async';

List<Payload> payloadFromJson(String str) =>
    List<Payload>.from(json.decode(str).map((x) => Payload.fromJson(x)));

String payloadToJson(List<Payload> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Payload {
  String sponsorlogo;

  Payload({
    required this.sponsorlogo,
  });

  factory Payload.fromJson(Map<String, dynamic> json) => Payload(
        sponsorlogo: json["sponsorlogo"] == null ? null : json["sponsorlogo"],
      );

  Map<String, dynamic> toJson() => {
        "sponsorlogo": sponsorlogo == null ? null : sponsorlogo,
      };
}

class CarouselDemo extends StatefulWidget {
  @override
  _CarouselDemoState createState() => _CarouselDemoState();
}

class _CarouselDemoState extends State<CarouselDemo> {
  Future<List<Payload>> getSponsorSlide() async {
    //final response = await http.get("getdata.php");
    //return json.decode(response.body);
    String response =
        '[{"sponsorlogo":"https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80"},{"sponsorlogo":"https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80"},{"sponsorlogo":"https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80"}]';
    var payloadList = payloadFromJson(response);
    return payloadList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Card(
          child: new FutureBuilder<List<Payload>>(
            future: getSponsorSlide(),
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);
              return snapshot.hasData && snapshot.data != null
                  ? new SponsorList(
                      snapshot.data as List<Payload>,
                    )
                  : new Center(child: new CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }
}

class SponsorList extends StatefulWidget {
  final List<Payload> list;
  const SponsorList(this.list, {Key? key}) : super(key: key);

  @override
  _SponsorListState createState() => _SponsorListState();
}

class _SponsorListState extends State<SponsorList> {
  // Wheater to loop through elements
  bool _loop = true;

  // Scroll controller for carousel
  late InfiniteScrollController _controller;

  // Maintain current index of carousel
  int _selectedIndex = 0;

  // Width of each item
  double _itemExtent = 300;

  // Get screen width of viewport.
  double get screenWidth => MediaQuery.of(context).size.width;

  double _anchor = 0.0;
  bool _center = true;
  double _velocityFactor = 0.2;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    // Initialize the scroll controller
    _controller = InfiniteScrollController(initialItem: _selectedIndex);
    // Automate the scroll 5 seconds delay.
    _timer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
      _controller.nextItem();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: SizedBox(
            height: 200,
            child: InfiniteCarousel.builder(
              itemCount: widget.list.length,
              itemExtent: _itemExtent,
              loop: _loop,
              center: _center,
              anchor: _anchor,
              velocityFactor: _velocityFactor,
              controller: _controller,
              onIndexChanged: (index) {
                if (_selectedIndex != index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                }
              },
              itemBuilder: (context, itemIndex, realIndex) {
                final currentOffset = _itemExtent * realIndex;
                return AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    final diff = (_controller.offset - currentOffset);
                    final maxPadding = 10.0;
                    final _carouselRatio = _itemExtent / maxPadding;

                    return Padding(
                      padding: EdgeInsets.only(
                        top: (diff / _carouselRatio).abs(),
                        bottom: (diff / _carouselRatio).abs(),
                      ),
                      child: child,
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.all(2.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: kElevationToShadow[2],
                        image: DecorationImage(
                          image: NetworkImage(
                              widget.list.elementAt(itemIndex).sponsorlogo),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                );
              },
            )),
      ),
    );
  }
}
