
import 'package:flutter/material.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_app/data/movie.dart';
import 'package:flutter_app/widgets/providers/list_items_provider.dart';
import 'package:provider/provider.dart';

class ListOfItems extends StatelessWidget {
  ListOfItems({this.data});

  final Data data;
  ListItemsProvider listItemsModel;

  @override
  Widget build(BuildContext context) {
    listItemsModel = Provider.of<ListItemsProvider>(context);
    listItemsModel.setDataList(data.movies);
    listItemsModel.setLastPageNumber(data.totalPages);

    return NotificationListener(
      onNotification: listItemsModel.onNotification,
      child:( _buildDataList(listItemsModel.getDataList(),listItemsModel.getScrollController())
      ),  // GridView.builder
    );
  }

  Widget _buildDataList(List<Movie> dataList, ScrollController scrollController){
    return new ListView.builder(
        controller: scrollController,
        itemCount: dataList.length,
        itemBuilder: (context, index)  => Padding(
            padding: EdgeInsets.all(15.0),
            child: _buildDataListItem(dataList[index])));
  }

  Widget _buildDataListItem(Movie movie){
    if(movie.posterPath==null){
      movie.posterPath="";
    }
    return ListTile(
      leading: new Container(
          width: 60,
          height: 60,
          decoration: new BoxDecoration(
              shape: BoxShape.circle,
              image: new DecorationImage(
                  fit: BoxFit.fill,
                  image: new NetworkImage("https://image.tmdb.org/t/p/"+"w300"+movie.posterPath)
              )
          )),
      title: Text(movie.title),
    );}
}


