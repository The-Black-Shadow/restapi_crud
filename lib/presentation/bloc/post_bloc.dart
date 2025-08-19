import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restapi_crud/data/models/post_model.dart';
import 'package:restapi_crud/domain/repositories/post_repository.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository postRepository;

  PostBloc({required this.postRepository}) : super(const PostState()) {
    on<LoadPosts>(_onLoadPosts);
    on<AddPost>(_onAddPost);
    on<UpdatePost>(_onUpdatePost);
    on<DeletePost>(_onDeletePost);
  }

  void _onLoadPosts(LoadPosts event, Emitter<PostState> emit) async {
    emit(state.copyWith(status: PostStatus.loading));
    try {
      final posts = await postRepository.getPosts();
      emit(state.copyWith(status: PostStatus.success, posts: posts));
    } catch (e) {
      emit(state.copyWith(status: PostStatus.failure, errorMessage: e.toString()));
    }
  }

  void _onAddPost(AddPost event, Emitter<PostState> emit) async {
    try {
      final newPost = await postRepository.createPost(event.post);
      final updatedPosts = List<Post>.from(state.posts)..add(newPost);
      emit(state.copyWith(posts: updatedPosts));
    } catch (e) {
      emit(state.copyWith(status: PostStatus.failure, errorMessage: 'Failed to add post.'));
    }
  }

  void _onUpdatePost(UpdatePost event, Emitter<PostState> emit) async {
    try {
      final updatedPost = await postRepository.updatePost(event.post);
      final updatedPosts = state.posts.map((post) {
        return post.id == updatedPost.id ? updatedPost : post;
      }).toList();
      emit(state.copyWith(posts: updatedPosts));
    } catch (e) {
       emit(state.copyWith(status: PostStatus.failure, errorMessage: 'Failed to update post.'));
    }
  }

  void _onDeletePost(DeletePost event, Emitter<PostState> emit) async {
    try {
      // Optimistic UI update
      final updatedPosts = state.posts.where((post) => post.id != event.postId).toList();
      emit(state.copyWith(posts: updatedPosts));
      await postRepository.deletePost(event.postId);
    } catch (e) {
      // If delete fails, reload the original list to revert the change
      add(LoadPosts());
    }
  }
}

