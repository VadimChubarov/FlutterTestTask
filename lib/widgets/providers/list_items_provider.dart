
import 'package:async/async.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_app/data/movie.dart';
import 'package:flutter_app/repository/network.dart';

class ListItemsProvider with ChangeNotifier {

  List<Movie> dataList;
  int currentPageNumber = 1;
  int lastPageNumber;
  CancelableOperation dataOperation;
  DataLoadMoreStatus loadMoreStatus = DataLoadMoreStatus.STABLE;
  final ScrollController scrollController = new ScrollController();

  getDataList() => dataList;
  getScrollController() => scrollController;

  setDataList(List<Movie> dataList) => this.dataList = dataList;
  setPageNumber(int pageNumber) => this.currentPageNumber = pageNumber;
  setLastPageNumber(int pageNumber) => this.lastPageNumber = pageNumber;

  bool onNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      checkForPagination();
    }
  }

  void checkForPagination() {
    if (scrollController.position.maxScrollExtent > scrollController.offset &&
        scrollController.position.maxScrollExtent - scrollController.offset <=
            100 && currentPageNumber < lastPageNumber) {
      if (loadMoreStatus != null &&
          loadMoreStatus == DataLoadMoreStatus.STABLE) {
        loadMoreStatus = DataLoadMoreStatus.LOADING;
        loadMoreItems();
      }
    }
  }

  void loadMoreItems() {
    dataOperation = CancelableOperation.fromFuture(
        MoviesNetwork.getInstance()
            .getPopularMovies(currentPageNumber + 1)
            .then((data) {
          currentPageNumber = data.page;
          loadMoreStatus = DataLoadMoreStatus.STABLE;
          showMoreItems(data);
        }
        )
    );
  }

  void showMoreItems(Data data) {
    dataList.addAll(data.movies);
    notifyListeners();
  }
}