
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_app/data/movie.dart';
import 'package:flutter_app/repository/network.dart';

class ListOfItems extends StatefulWidget {

  final Data data;

  ListOfItems({Key key, this.data}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ListOfItemsState();
}

class ListOfItemsState extends State<ListOfItems>{

  List<Movie> dataList;
  DataLoadMoreStatus loadMoreStatus = DataLoadMoreStatus.STABLE;
  final ScrollController scrollController = new ScrollController();
  int currentPageNumber;
  int lastPageNumber;
  CancelableOperation  dataOperation;

  @override
  void initState() {
    dataList = widget.data.movies;
    currentPageNumber = widget.data.page;
    lastPageNumber = widget.data.totalPages;
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    if(dataOperation != null) dataOperation.cancel();
    super.dispose();
  }

  bool onNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      if (scrollController.position.maxScrollExtent > scrollController.offset &&
          scrollController.position.maxScrollExtent - scrollController.offset <=
              50 && currentPageNumber < lastPageNumber) {
        if (loadMoreStatus != null &&
            loadMoreStatus == DataLoadMoreStatus.STABLE) {
          loadMoreStatus = DataLoadMoreStatus.LOADING;
          dataOperation = CancelableOperation.fromFuture(
              MoviesNetwork.getInstance()
                  .getPopularMovies(currentPageNumber + 1)
                  .then((data) {
                currentPageNumber = data.page;
                loadMoreStatus = DataLoadMoreStatus.STABLE;
                setState(() => dataList.addAll(data.movies));
              }));
        }
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: onNotification,
      child:( _buildDataList(dataList)
      ),  // GridView.builder
    );
  }

  Widget _buildDataList(List<Movie> dataList){
    return new ListView.builder(
        controller: scrollController,
        itemCount: dataList.length,
        itemBuilder: (context, index)  => Padding(
            padding: EdgeInsets.all(15.0),
            child: _buildDataListItem(dataList[index])));
  }

  Widget _buildDataListItem(Movie movie){
    if(movie.posterPath==null){movie.posterPath="";}
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