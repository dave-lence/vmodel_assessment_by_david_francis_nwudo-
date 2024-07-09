class BlogPost {
  final String id;
  final String title;
  final String subTitle;
  final String body;
  final String dateCreated;

  BlogPost({
    required this.id,
    required this.title,
    required this.subTitle,
    required this.body,
    required this.dateCreated,
  });

  factory BlogPost.fromJson(Map<String, dynamic> json) {
    return BlogPost(
      id: json['id'] as String,
      title: json['title'] as String,
      subTitle: json['subTitle'] as String,
      body: json['body'] as String,
      dateCreated: json['dateCreated'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subTitle': subTitle,
      'body': body,
      'dateCreated': dateCreated,
    };
  }
}
