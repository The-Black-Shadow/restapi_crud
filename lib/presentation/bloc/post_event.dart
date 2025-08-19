part of 'post_bloc.dart';

sealed class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object> get props => [];
}

class LoadPosts extends PostEvent {}

class AddPost extends PostEvent {
  final Post post;
  const AddPost(this.post);
  @override
  List<Object> get props => [post];
}

class UpdatePost extends PostEvent {
  final Post post;
  const UpdatePost(this.post);
  @override
  List<Object> get props => [post];
}

class DeletePost extends PostEvent {
  final String postId;
  const DeletePost(this.postId);
  @override
  List<Object> get props => [postId];
}
