class Tree {
  Tree({
      this.sha, 
      this.url,});

  Tree.fromJson(dynamic json) {
    sha = json['sha'];
    url = json['url'];
  }
  String? sha;
  String? url;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['sha'] = sha;
    map['url'] = url;
    return map;
  }

}