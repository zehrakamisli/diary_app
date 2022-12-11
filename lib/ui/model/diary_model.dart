class DiaryModel {
  String? id;
  DateTime? dateTime;
  String? title;
  String? content;
  String? image;

  DiaryModel({this.id, this.dateTime, this.title, this.content, this.image});

  DiaryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dateTime =
        json['dateTime'] == null ? null : DateTime.tryParse(json['dateTime']);
    title = json['title'];
    content = json['content'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['dateTime'] = dateTime?.toIso8601String();
    data['title'] = title;
    data['content'] = content;
    data['image'] = image;
    return data;
  }
}
