class Author {
  Author({
      this.name, 
      this.email, 
      this.date,});

  Author.fromJson(dynamic json) {
    name = json['name'];
    email = json['email'];
    date = json['date'];
  }
  String? name;
  String? email;
  String? date;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['email'] = email;
    map['date'] = date;
    return map;
  }

}