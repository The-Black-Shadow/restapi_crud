import '../../domain/repositories/post_repository.dart';
import '../models/post_model.dart';
import '../services/post_api_service.dart';

class ApiPostRepository implements PostRepository {
  final PostApiService _postApiService;

  ApiPostRepository(this._postApiService);

  @override
  Future<List<Post>> getPosts() => _postApiService.getPosts();

  @override
  Future<Post> createPost(Post post) => _postApiService.createPost(post);

  @override
  Future<Post> updatePost(Post post) => _postApiService.updatePost(post);

  @override
  Future<void> deletePost(String postId) => _postApiService.deletePost(postId);
}
