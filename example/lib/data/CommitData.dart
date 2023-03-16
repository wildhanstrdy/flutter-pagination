import 'package:flutter_pagination/pagination/paged_item.dart';

import 'Commit.dart';

class CommitData implements PagedItem{
  CommitData({
      required this.sha,
      required this.nodeId,
      this.commit,
      this.url,
      this.htmlUrl,
      this.commentsUrl,});

  CommitData.fromJson(dynamic json) {
    sha = json['sha'];
    nodeId = json['node_id'];
    commit = (json['commit'] != null ? Commit.fromJson(json['commit']) : null)!;
    url = json['url'];
    htmlUrl = json['html_url'];
    commentsUrl = json['comments_url'];
  }
  String? sha;
  String? nodeId;
  Commit? commit;
  String? url;
  String? htmlUrl;
  String? commentsUrl;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['sha'] = sha;
    map['node_id'] = nodeId;
    if (commit != null) {
      map['commit'] = commit!.toJson();
    }
    map['url'] = url;
    map['html_url'] = htmlUrl;
    map['comments_url'] = commentsUrl;
    return map;
  }

}