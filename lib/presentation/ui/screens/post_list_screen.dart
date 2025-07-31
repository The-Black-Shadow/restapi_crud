import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:restapi_crud/presentation/bloc/bloc/post_bloc.dart';
import 'add_edit_post_screen.dart';

class PostListScreen extends StatelessWidget {
  const PostListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Trigger the initial load when the screen is built
    context.read<PostBloc>().add(LoadPosts());

    return Scaffold(
      appBar: AppBar(title: const Text('CRUD with MockAPI')),
      body: BlocConsumer<PostBloc, PostState>(
        listener: (context, state) {
          if (state.status == PostStatus.failure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.errorMessage)));
          }
        },
        builder: (context, state) {
          if (state.status == PostStatus.loading ||
              state.status == PostStatus.initial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == PostStatus.success) {
            if (state.posts.isEmpty) {
              return const Center(child: Text('No posts found. Add one!'));
            }
            return ListView.builder(
              itemCount: state.posts.length,
              itemBuilder: (context, index) {
                final post = state.posts[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  child: ListTile(
                    //add createdAt
                    leading: Text(
                      DateFormat('MMM dd\nyy HH:mm').format(post.createdAt),
                      style: const TextStyle(fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                    title: Text(
                      post.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(post.body),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => AddEditPostScreen(post: post),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () =>
                              _showDeleteConfirmation(context, post.id!),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return const Center(child: Text('Something went wrong!'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const AddEditPostScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String postId) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Delete Post'),
          content: const Text('Are you sure you want to delete this post?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: () {
                // Use the BLoC from the main context to dispatch the event
                context.read<PostBloc>().add(DeletePost(postId));
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
