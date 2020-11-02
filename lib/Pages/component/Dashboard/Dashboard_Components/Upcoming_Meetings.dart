import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../Cards/Meeting_Cards.dart';

class Upcoming_Meetings extends StatelessWidget {
  const Upcoming_Meetings({
    Key key,
    @required this.upcomingMeetings,
  }) : super(key: key);

  final List upcomingMeetings;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        aspectRatio: 12.5 / 9.0,
        enlargeCenterPage: true,
        enableInfiniteScroll: false,
        initialPage: 2,
        autoPlay: false,
      ),
      items: upcomingMeetings.map((upcomingMeeting) {
        return Meeting_Card(
          meeting: upcomingMeeting,
        );
      }).toList(),
    );
  }
}
