import 'Author.dart';
import 'Tree.dart';

class Commit {
  Commit({
      this.author, 
      this.message, 
      this.tree,});

  Commit.fromJson(dynamic json) {
    author = json['author'] != null ? Author.fromJson(json['author']) : null;
    message = json['message'];
    tree = json['tree'] != null ? Tree.fromJson(json['tree']) : null;
  }
  Author? author;
  String? message;
  Tree? tree;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (author != null) {
      map['author'] = author!.toJson();
    }
    map['message'] = message;
    if (tree != null) {
      map['tree'] = tree!.toJson();
    }
    return map;
  }

}