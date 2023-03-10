import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PaginationView extends ListView {
  final Widget loadMoreView;
  final Widget loadMoreErrorView;
  final Widget itemView;


  PaginationView({
    Key? key,
    required this.itemView,
    required this.loadMoreView,
    required this.loadMoreErrorView,
  }) : super(key: key);

  @override
  ListView createState() {
    return ListView.separated(itemBuilder: (index,item){

    }, separatorBuilder: (index,item){
      return const Divider();
    }, itemCount: 0);
  }
}
