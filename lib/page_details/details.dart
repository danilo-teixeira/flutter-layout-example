import 'dart:async';
import 'package:flutter/material.dart';
import 'package:map_view/map_view.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'favorite_button.dart';

const CLOSE_ACTION = 1;

class DetailsPage extends StatefulWidget {
  @override
  _DetailsPageWidgetState createState() => new _DetailsPageWidgetState();

}

class _DetailsPageWidgetState extends State<DetailsPage> {
  
  var data = {
    'name': 'Oeschinen Lake Campground',
    'image': 'images/lake.jpg',
    'description': 'Lake Oeschinen lies at the foot of the Blüemlisalp in the Bernese Alps. Situated 1,578 meters above sea level, it is one of the larger Alpine Lakes. A gondola ride from Kandersteg, followed by a half-hour walk through pastures and pine forest, leads you to the lake, which warms to 20 degrees Celsius in the summer. Activities enjoyed here include rowing, and riding the summer toboggan run.',
    'state': 'Kandersteg',
    'country': 'Switzerland',
    'lat': 46.4973186,
    'lon': 7.7148234,
    'phone': '91234-1234'
  };

  showMap(title, lat, lon) {
    MapView mapView = new MapView();
    CompositeSubscription compositeSubscription = new CompositeSubscription();

    mapView.show(
      new MapOptions(
        mapViewType: MapViewType.normal,
        showUserLocation: true,
        initialCameraPosition: new CameraPosition( new Location(lat, lon),14.0),
        title: "Location"
      ),
      toolbarActions: <ToolbarAction>[new ToolbarAction('Close', CLOSE_ACTION)]
    );

    var sub = mapView.onMapReady.listen((_) {
      mapView.addMarker(new Marker("1", title, lat, lon, color: Colors.purple));
      mapView.zoomToFit(padding: 100);
    });
    compositeSubscription.add(sub);

    sub = mapView.onLocationUpdated
      .listen((location) => print("Location updated $location"));
    compositeSubscription.add(sub);

    sub = mapView.onTouchAnnotation
      .listen((annotation) => print("annotation tapped"));
    compositeSubscription.add(sub);

    sub = mapView.onMapTapped
      .listen((location) => print("Touched location $location"));
    compositeSubscription.add(sub);

    sub = mapView.onCameraChanged
      .listen((cameraPosition) => print("cameraPosition: $cameraPosition"));
    compositeSubscription.add(sub);

    // TODO: check the close function
    sub = mapView.onToolbarAction.listen((id) {
      print("Close $id - $CLOSE_ACTION");
      if (id == CLOSE_ACTION) {
        mapView.dismiss();
        compositeSubscription.cancel();
      }
    });
    compositeSubscription.add(sub);

    sub = mapView.onInfoWindowTapped
      .listen((marker) => print("Info Window Tapped for ${marker.title}"));
    compositeSubscription.add(sub);
  }

  @override
  build(BuildContext context) {
    Widget titleSection = new Container(
      padding: const EdgeInsets.all(32.0),
      child: new Row(
        children: <Widget>[
          new Expanded(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Container(
                  padding: const EdgeInsets.only(bottom:8.0),
                  child: new Text(
                    this.data['name'],
                    style: new TextStyle(
                      fontWeight: FontWeight.bold
                    )
                  )
                ),
                new Text(
                  "${this.data['state']}, ${this.data['country']}",
                  style: new TextStyle(
                    color: Colors.grey[500]
                  ),
                )
              ],
            ),
          ),
          new FavoriteWidget()
        ],
      ),
    );

    Column buildButtomColumn( IconData icon, String label, Function onPressed) {
      Color color = Theme.of(context).primaryColor;

      return new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new IconButton(
            icon: new Icon(
              icon,
              color: color,
            ),
            onPressed: onPressed,
          ),
          new Container(
            margin: const EdgeInsets.only(top:8.0),
            child: new Text(
              label,
              style: new TextStyle(
                color: color,
                fontSize: 12.0,
                fontWeight: FontWeight.w400
              ),
            )
          )
        ],
      );
    }

    void shareItem() {
      share("${this.data['name']} - ${this.data['state']}, ${this.data['country']}");
    }

    void getLocation() {
      showMap("${this.data['name']} - ${this.data['state']}, ${this.data['country']}", this.data['lat'], this.data['lon']);
    }

    void call(){
      launch("tel:${this.data['phone']}");
    }

    Widget buttomSection = new Container(
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          buildButtomColumn(Icons.call, "CALL", call),
          buildButtomColumn(Icons.near_me, "LOCATION", getLocation),
          buildButtomColumn(Icons.share, "SHARE", shareItem),
        ],
      ),
    );

    Widget textSection = new Container(
      padding: const EdgeInsets.all(32.0),
      child: new Text(
        this.data['description'],
        softWrap: true,
      ),
    );

    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Layout demo'),
        ),
        body: new ListView(
          children: <Widget>[
            new Image.asset(
              this.data['image'],
              fit: BoxFit.cover,
            ),
            titleSection,
            buttomSection,
            textSection
          ],
        )
    );
  }
}

// TODO: extract the class to another file
class CompositeSubscription {
  Set<StreamSubscription> _subscriptions = new Set();

  void cancel() {
    for (var n in this._subscriptions) {
      n.cancel();
    }
    this._subscriptions = new Set();
  }

  void add(StreamSubscription subscription) {
    this._subscriptions.add(subscription);
  }

  void addAll(Iterable<StreamSubscription> subs) {
    _subscriptions.addAll(subs);
  }

  bool remove(StreamSubscription subscription) {
    return this._subscriptions.remove(subscription);
  }

  bool contains(StreamSubscription subscription) {
    return this._subscriptions.contains(subscription);
  }

  List<StreamSubscription> toList() {
    return this._subscriptions.toList();
  }
}