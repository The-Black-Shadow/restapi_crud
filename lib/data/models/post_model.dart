import 'package:equatable/equatable.dart';

class Post extends Equatable {
  final String? id;
  final String title;
  final String body;
  final DateTime createdAt;

  const Post({
    this.id,
    required this.title,
    required this.body,
    required this.createdAt,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'body': body};
  }

  @override
  List<Object?> get props => [id, title, body];
}
