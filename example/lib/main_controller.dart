import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_pagination/pagination/common_pagination.dart';
import 'package:flutter_pagination/pagination/pagination_result.dart';
import 'package:flutter_pagination_example/api_service.dart';
import 'package:flutter_pagination_example/data/CommitData.dart';
import 'package:flutter_pagination_example/state.dart';
import 'package:get/get.dart';

class MainController extends GetxController {
  static const perPage = 20;
  final Dio _dio = APIService.getInstance();
  final Rx<State> state = State.idle.obs;
  RxList<CommitData> data = List<CommitData>.empty(growable: true).obs;
  CommonPagination<CommitData> pagination = CommonPagination(perPage);

  Future fetchCommit() async {
    return await pagination.loadItems(
        false,
        (loadFromIndex, isInitial) {
          try {
            int page = 1;
            print('asdf55 Page: $page || ${loadFromIndex / perPage}');
            if (loadFromIndex != 0) {
              page = loadFromIndex ~/ perPage;
            }
            return fetchFromServer(page);
          } catch (e) {
            rethrow;
          }
        },
        (initialItems) =>
            {data.assignAll(initialItems), state.value = State.success,print('asdf55 loadInitialItem $initialItems')},
        (loadMoreItems) =>
            {data.assignAll(loadMoreItems), state.value = State.idle,print('asdf55 LoadMoreItems $loadMoreItems')},
        (initialLoadErrorMessage) =>
            {state.value = State.failed, print('asdf55 initialLoadmore Error $initialLoadErrorMessage')},
        (loadMoreErrorMessage) => {
          state.value = State.errorLoadMore,
          print('asdf55 loadMoreErrorMessage Error $loadMoreErrorMessage')
        },
        (isLoading, isLoadMore) {
          if (isLoading && isLoadMore) {
            print('asdf55 pagination loading');
            state.value = State.loadingMore;
          } else if (isLoading) {
            state.value = State.loading;
          }
        });
  }

  Future<PaginationResult> fetchFromServer(int page) async {
    try {
      var result = await _dio.get('repos/mojombo/grit/commits',
          queryParameters: {'page': page, 'per_page': perPage});
      var mappedResult =
          (result.data as List).map((e) => CommitData.fromJson(e)).toList();
      if (result.statusCode == 200 && mappedResult.isNotEmpty) {
        return ResultSuccess(mappedResult);
      } else {
        return ResultError(Exception('Error'), 'error fetch data');
      }
    } catch (error) {
      error.printError();
      return ResultError(Exception('error'), 'error');
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchCommit();
  }
}
