
import 'package:flutter_pagination/pagination/paged_item.dart';

abstract class PaginationResult{

}

class ResultSuccess extends PaginationResult{
  List<PagedItem> items = List.empty(growable: true);
  ResultSuccess(this.items);
}

class ResultError extends PaginationResult{
  final String? errorMessage;
  final Exception? exception;
  ResultError(this.exception,this.errorMessage);
}
