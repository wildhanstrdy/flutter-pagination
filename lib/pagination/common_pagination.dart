import 'package:flutter/foundation.dart';
import 'package:flutter_pagination/pagination/paged_item.dart';
import 'package:flutter_pagination/pagination/pagination_result.dart';

class CommonPagination<ITEM> {
  static const DEFAULT_PER_PAGE_COUNT = 20;
  int _perPage = DEFAULT_PER_PAGE_COUNT;
  bool _isLastPage = false;
  bool _isPerformingRequest = false;
  List<ITEM> _pagedItems = List.empty(growable: true);

  CommonPagination(this._perPage);
  CommonPagination.getDefault() {
    this._perPage = DEFAULT_PER_PAGE_COUNT;
  }

  void _logMe(Object object) {
    if (kDebugMode) print('PAGINATION_LOG: ${object}');
  }

  Future loadItems(
      bool forceRefresh,
      Future<PaginationResult> Function(int loadFromIndex,bool isInitial) loadFunction,
      Function(List<ITEM> initialItems) initialSuccess,
      Function(List<ITEM> loadMoreItems) loadMoreSuccess,
      Function(String initialLoadErrorMessage) initialFailed,
      Function(String loadMoreErrorMessage) loadMoreFailed,
      Function(bool isLoading, bool isLoadMore) loadingState) async {
    if(forceRefresh){
      _pagedItems.clear();
      _isLastPage = false;
    }
    _logMe('initialCheck forcedToRefresh:$forceRefresh PerformingRequest:$_isPerformingRequest IsLastPage:$_isLastPage');
    if (_isPerformingRequest || _isLastPage) return;
    _isPerformingRequest = true;
    loading(loadingState);
    PaginationResult result = await loadFunction(_pagedItems.length,isInitial());
    switch (result.runtimeType) {
      case ResultSuccess:
        result as ResultSuccess;
        if (result.items is List<PagedItem>) {
          List<ITEM> pagedItems = (result.items as List<PagedItem>).map((e) => e as ITEM).toList();
          if(pagedItems.isEmpty) _isLastPage = true;
          success(pagedItems, initialSuccess, loadMoreSuccess,loadingState);
        } else {
          //Dev must aware
          throw Exception(
              'Your returned item from load function is not the same type with the generic type');
        }
        break;
      case ResultError:
        result as ResultError;
        error(result.errorMessage, initialFailed, loadMoreFailed,loadingState);
        break;
      default:
        result as ResultError;
        error(result.errorMessage, initialFailed, loadMoreFailed,loadingState);
    }
  }

  void loading(Function(bool isLoading, bool isLoadMore) loadingState) {
    if (isInitial()) {
      _logMe('initialLoading');
      loadingState(_isPerformingRequest, false);
    } else {
      _logMe('loadMoreLoading');
      loadingState(_isPerformingRequest, true);
    }
  }

  void success(
      List<ITEM> items,
      Function(List<ITEM> items) initialSuccess,
      Function(List<ITEM> items) loadMoreSuccess,
      Function(bool isLoading, bool isLoadMore) loadingState) {
    if (isInitial()) {
      _pagedItems.clear();
      _pagedItems.addAll(items);
      initialSuccess(_pagedItems);
      _logMe('initialSuccess ${_pagedItems.length} |Page: ${getCurrentPage()}');
    } else {
      _pagedItems.addAll(items);
      loadMoreSuccess(_pagedItems);
      _logMe(
          'loadMoreSuccess ${_pagedItems.length} |Page: ${getCurrentPage()}');
    }
    _isPerformingRequest = false;
    loading(loadingState);
  }

  void error(
      String? message,
      Function(String message) initialFailed,
      Function(String message) loadMoreFailed,
      Function(bool isLoading, bool isLoadMore) loadingState) {
    if (isInitial()) {
      _logMe('initialFailed $message');
      initialFailed(message ?? 'Gagal memuat data.');
    } else {
      _logMe('loadMoreFailed $message');
      loadMoreFailed(message ?? 'Gagal memuat halaman selanjutnya.');
    }
    _isPerformingRequest = false;
    loading(loadingState);
  }

  bool isInitial() {
    return _pagedItems.isEmpty;
  }

  int getCurrentPage() {
    int itemSize = _pagedItems.length;
    if (itemSize == 0) return 0;
    dynamic page = itemSize / _perPage;
    if (itemSize > 0 && page > 0 && page < 1) {
      return 1;
    } else {
      if (page is double) {
        return page.toInt() + 1;
      } else {
        return page;
      }
    }
  }
}
