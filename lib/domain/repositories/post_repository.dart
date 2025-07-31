import 'package:dio/dio.dart';
import '../../data/models/post_model.dart';
import '../../data/services/post_api_service.dart';

class PostRepository {
  final PostApiService _postApiService;

  PostRepository({PostApiService? postApiService})
    : _postApiService = postApiService ?? PostApiService(dio: Dio());

  Future<List<Post>> getPosts() => _postApiService.getPosts();
  Future<Post> createPost(Post post) => _postApiService.createPost(post);
  Future<Post> updatePost(Post post) => _postApiService.updatePost(post);
  Future<void> deletePost(String postId) => _postApiService.deletePost(postId);
}
