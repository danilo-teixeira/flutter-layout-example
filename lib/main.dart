import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
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
                    "Oeschinen Lake Campground",
                    style: new TextStyle(
                      fontWeight: FontWeight.bold
                    )
                  )
                ),
                new Text(
                  "Kandersteg, Switzerland",
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

    Column buildButtomColumn( IconData icon, String label) {
      Color color = Theme.of(context).primaryColor;

      return new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Icon(
            icon,
            color: color,
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

    Widget buttomSection = new Container(
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          buildButtomColumn(Icons.call, "CALL"),
          buildButtomColumn(Icons.near_me, "ROUTE"),
          buildButtomColumn(Icons.share, "SHARE"),
        ],
      ),
    );

    Widget textSection = new Container(
      padding: const EdgeInsets.all(32.0),
      child: new Text(
        '''Lake Oeschinen lies at the foot of the Blüemlisalp in the Bernese Alps. Situated 1,578 meters above sea level, it is one of the larger Alpine Lakes. A gondola ride from Kandersteg, followed by a half-hour walk through pastures and pine forest, leads you to the lake, which warms to 20 degrees Celsius in the summer. Activities enjoyed here include rowing, and riding the summer toboggan run.''',
        softWrap: true,
      ),
    );

    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new Scaffold(
        appBar: new AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: new Text('Layout demo'),
        ),
        body: new ListView(
          children: <Widget>[
            new Image.asset(
              'images/lake.jpg',
              fit: BoxFit.cover,
            ),
            titleSection,
            buttomSection,
            textSection
          ],
        )
    ),
    );
  }
}

class FavoriteWidget extends StatefulWidget {
  @override
  _FavoriteWidgetState createState() => new _FavoriteWidgetState();
}

class _FavoriteWidgetState extends State<FavoriteWidget> {
  bool _isFavorited = true;
  int _favoriteCount = 41;

  void _toggleFavorite() {
    setState(() {
      // If the lake is currently favorited, unfavorite it.
      if (_isFavorited) {
        _favoriteCount -= 1;
        _isFavorited = false;
        // Otherwise, favorite it.
      } else {
        _favoriteCount += 1;
        _isFavorited = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        new Container(
          padding: new EdgeInsets.all(0.0),
          child: new IconButton(
            icon: (_isFavorited
                ? new Icon(Icons.star)
                : new Icon(Icons.star_border)),
            color: Colors.red[500],
            onPressed: _toggleFavorite,
          ),
        ),
        new SizedBox(
          width: 18.0,
          child: new Container(
            child: new Text('$_favoriteCount'),
          ),
        ),
      ],
    );
  }
}