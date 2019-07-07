
import 'package:flutter/material.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_app/widgets/item_list_widget.dart';
import 'package:flutter_app/repository/network.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;
  NetworkRepository network = MoviesNetwork.getInstance();

  @override
  _MyHomePageState createState() => _MyHomePageState(network.getPopularMovies(1));
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState(this.data);

  Future<Data> data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: FutureBuilder<Data>(
          future: data,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListOfItems(data:snapshot.data);
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return CircularProgressIndicator();
          },
        ),
      ),
      bottomNavigationBar : BottomNavigationBar(
        currentIndex: 0,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.movie),
            title: new Text('Movies'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.add_comment),
            title: new Text('Comments'),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_location),
              title: Text('Locale')
          )
        ],
      ),
    );
  }
}