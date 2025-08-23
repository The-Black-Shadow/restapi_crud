import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restapi_crud/presentation/bloc/post/post_bloc.dart';
import 'package:restapi_crud/presentation/bloc/search/search_bloc.dart';
import '../../../data/models/post_model.dart';
import 'add_edit_post_screen.dart';

class PostListScreen extends StatelessWidget {
  const PostListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<PostBloc>().add(LoadPosts());

    return Scaffold(
      appBar: AppBar(title: const Text('CRUD & Search')),
      body: Column(
        children: [
          _buildSearchBar(context),
          Expanded(
            child: BlocBuilder<PostBloc, PostState>(
              builder: (context, postState) {
                if (postState.status == PostStatus.loading ||
                    postState.status == PostStatus.initial) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (postState.status == PostStatus.failure) {
                  return Center(
                    child: Text(
                      'Failed to fetch posts: ${postState.errorMessage}',
                    ),
                  );
                }
                if (postState.status == PostStatus.success) {
                  return BlocBuilder<SearchBloc, SearchState>(
                    builder: (context, searchState) {
                      final filteredPosts = _filterPosts(
                        postState.posts,
                        searchState.query,
                      );

                      if (filteredPosts.isEmpty) {
                        return const Center(child: Text('No posts found.'));
                      }

                      return ListView.builder(
                        itemCount: filteredPosts.length,
                        itemBuilder: (context, index) {
                          final post = filteredPosts[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 16,
                            ),
                            child: ListTile(
                              title: Text(
                                post.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(post.body),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.blue,
                                    ),
                                    onPressed: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            AddEditPostScreen(post: post),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () => _showDeleteConfirmation(
                                      context,
                                      post.id!,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                }
                return const Center(child: Text('Something went wrong!'));
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const AddEditPostScreen())),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        decoration: const InputDecoration(
          labelText: 'Search Posts',
          hintText: 'Enter title or body content...',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(),
        ),
        onChanged: (query) {
          context.read<SearchBloc>().add(SearchQueryChanged(query));
        },
      ),
    );
  }

  List<Post> _filterPosts(List<Post> posts, String query) {
    if (query.isEmpty) {
      return posts;
    }
    final lowerCaseQuery = query.toLowerCase();
    return posts.where((post) {
      final titleMatch = post.title.toLowerCase().contains(lowerCaseQuery);
      final bodyMatch = post.body.toLowerCase().contains(lowerCaseQuery);
      return titleMatch || bodyMatch;
    }).toList();
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
