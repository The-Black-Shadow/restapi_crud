import 'package:dio/dio.dart';
import '../models/post_model.dart';

class PostApiService {
  final Dio _dio;
  final String _baseUrl =
      'https://688863a4adf0e59551b9c117.mockapi.io/api/v1/posts';

  PostApiService({Dio? dio}) : _dio = dio ?? Dio();

  // READ all posts
  Future<List<Post>> getPosts() async {
    try {
      final response = await _dio.get(_baseUrl);
      print('Response data: ${response.data}');
      final result = (response.data as List)
          .map((post) => Post.fromJson(post))
          .toList();
      print('Parsed posts: $result');
      return result;
    } catch (e) {
      throw Exception('Failed to load posts');
    }
  }

  // CREATE a new post
  Future<Post> createPost(Post post) async {
    try {
      final response = await _dio.post(_baseUrl, data: post.toJson());
      print('Create post data: ${response.data}');
      return Post.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create post');
    }
  }

  // UPDATE a post
  Future<Post> updatePost(Post post) async {
    try {
      final response = await _dio.put(
        '$_baseUrl/${post.id}',
        data: post.toJson(),
      );
      return Post.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update post');
    }
  }

  // DELETE a post
  Future<void> deletePost(String postId) async {
    try {
      await _dio.delete('$_baseUrl/$postId');
    } catch (e) {
      throw Exception('Failed to delete post');
    }
  }
}
