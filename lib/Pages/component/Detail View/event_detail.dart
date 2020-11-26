import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mrcci_ec/firebase%20services/firestore_service.dart';
import 'package:mrcci_ec/models/meetings.dart';

class EventDetailView extends StatefulWidget {
  @override
  EventDetailViewState createState() => EventDetailViewState();
  var event;
  EventDetailView({this.event});
}

class EventDetailViewState extends State<EventDetailView>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    // "Unmount" the controllers:
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //appState = StateWidget.of(context).state;

    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool innerViewIsScrolled) {
          return <Widget>[
            SliverAppBar(
              backgroundColor: Colors.white,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    RecipeImage(widget.event['photoUrl']),
                    RecipeTitle(widget.event, 20.0),
                  ],
                ),
              ),
              expandedHeight: 340.0,
              pinned: true,
              floating: true,
              elevation: 2.0,
              forceElevated: innerViewIsScrolled,
              bottom: TabBar(
                tabs: <Widget>[
                  Tab(
                    child: Text(
                      'Descrtiption',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Presenters',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
                controller: _tabController,
              ),
            )
          ];
        },
        body: TabBarView(
          children: <Widget>[
            IngredientsView(widget.event['description']),
            PreparationView(widget.event['presenters']),
          ],
          controller: _tabController,
        ),
      ),
    );
  }
}

class IngredientsView extends StatelessWidget {
  final String ingredients;

  IngredientsView(this.ingredients);

  @override
  Widget build(BuildContext context) {
    List<Widget> children = new List<Widget>();
    children.add(
      new Row(
        children: <Widget>[
          // new Icon(Icons.done),
          // new SizedBox(width: 5.0),
          Expanded(child: new Text(ingredients)),
        ],
      ),
    );
    // Add spacing between the lines:
    children.add(
      new SizedBox(
        height: 5.0,
      ),
    );
    return ListView(
      padding: EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 75.0),
      children: children,
    );
  }
}

class PreparationView extends StatelessWidget {
  final String preparationSteps;

  PreparationView(this.preparationSteps);

  @override
  Widget build(BuildContext context) {
    List<Widget> textElements = List<Widget>();
    textElements.add(
      Text(preparationSteps != null
          ? preparationSteps
          : 'No Meeting Notes yet.'),
    );
    // Add spacing between the lines:
    textElements.add(
      SizedBox(
        height: 10.0,
      ),
    );
    return ListView(
      padding: EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 75.0),
      children: textElements,
    );
  }
}

class RecipeImage extends StatelessWidget {
  final String imageURL;

  RecipeImage(this.imageURL);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16.0 / 9.0,
      child: imageURL != null
          ? Image.network(
              imageURL,
              fit: BoxFit.cover,
            )
          : Image.asset(
              'assets/images/meeting.jpeg',
              fit: BoxFit.cover,
            ),
    );
  }
}

class RecipeTitle extends StatelessWidget {
  var meeting;
  final double padding;

  RecipeTitle(this.meeting, this.padding);

  @override
  Widget build(BuildContext context) {
    Timestamp date = meeting['dateFlutter'];
    var toFormat = DateTime.parse(date.toDate().toString());
    var formattedDate = "${toFormat.day}-${toFormat.month}-${toFormat.year}";
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Column(
        // Default value for crossAxisAlignment is CrossAxisAlignment.center.
        // We want to align title and description of recipes left:
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            meeting['title'],
            style: TextStyle(fontSize: 20),
          ),
          // Empty space:
          SizedBox(height: 10.0),
          Row(
            children: [
              Icon(Icons.calendar_view_day, size: 20.0),
              SizedBox(width: 5.0),
              Text(
                formattedDate,
                style: Theme.of(context).textTheme.caption,
              ),
              SizedBox(width: 10.0),
              Icon(Icons.timer, size: 20.0),
              SizedBox(width: 5.0),
              Text(
                meeting['time'],
                style: Theme.of(context).textTheme.caption,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
