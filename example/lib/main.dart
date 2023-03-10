import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pagination_example/main_controller.dart';
import 'package:get/get.dart';
import 'package:flutter_pagination_example/state.dart' as st;

import 'data/CommitData.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _mainController = Get.put(MainController());
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      _mainController.fetchCommit();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetX<MainController>(builder: (controller) {
      return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text('Plugin example app'),
            ),
            body: renderBody(controller)),
      );
    });
  }

  Widget renderBody(MainController controller) {
    switch (controller.state.value) {
      case st.State.failed:
        return Container(
          alignment: Alignment.center,
          child: InkWell(
            child: const Text('an error happened, please click to refresh'),
            onTap: () {
              controller.fetchCommit();
            },
          ),
        );
      case st.State.loading:
        return _progressLoading();
      case st.State.loadingMore:
      case st.State.errorLoadMore:
      case st.State.success:
      case st.State.idle:
        return createBodyList(controller.state.value, controller.data);
    }
  }

  Widget _progressLoading() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        alignment: Alignment.center,
        child: const CircularProgressIndicator(),
      ),
    );
  }

  Widget _createErrorMoreUI() {
    return Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: CupertinoColors.systemGrey2
        ),
        child: InkWell(
          child:const Padding(
            padding: EdgeInsets.all(16),
            child:  Text(
              'Error load more data',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
          ),
          onTap: () {
            _mainController.fetchCommit();
          },
        ));
  }

  Widget createBodyList(st.State currentState, List<CommitData> data) {
    var hasMoreItem = currentState == st.State.errorLoadMore ||
        currentState == st.State.loadingMore;
    return ListView.separated(
      itemBuilder: (context, index) {
        if (index >= data.length) {
          if (currentState == st.State.loadingMore) {
            return _progressLoading();
          } else {
            return _createErrorMoreUI();
          }
        } else {
          return listItem(data[index].commit?.author?.name);
        }
      },
      separatorBuilder: (context, index) => Divider(),
      itemCount: data.length + (hasMoreItem ? 1 : 0),
      controller: _scrollController,
    );
  }

  Widget listItem(String? name) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        '$name',
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
    );
  }
}
