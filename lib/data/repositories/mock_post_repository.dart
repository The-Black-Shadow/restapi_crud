import 'dart:convert';
import 'package:flutter/services.dart';
import '../../domain/repositories/post_repository.dart';
import '../models/post_model.dart';

class MockPostRepository implements PostRepository {
  List<Post> _posts = [];
  bool _initialized = false;

  Future<void> _initialize() async {
    if (!_initialized) {
      final String response = await rootBundle.loadString('assets/posts.json');
      final data = await json.decode(response) as List;
      _posts = data.map((json) => Post.fromJson(json)).toList();
      _initialized = true;
    }
  }

  @override
  Future<List<Post>> getPosts() async {
    await _initialize();
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return List<Post>.from(_posts);
  }

  @override
  Future<Post> createPost(Post post) async {
    await _initialize();
    await Future.delayed(const Duration(milliseconds: 300));
    final newPost = Post(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: post.title,
      body: post.body,
      createdAt: DateTime.parse(post.createdAt.toIso8601String()),
    );
    _posts.add(newPost);
    return newPost;
  }

  @override
  Future<void> deletePost(String postId) async {
    await _initialize();
    await Future.delayed(const Duration(milliseconds: 300));
    _posts.removeWhere((post) => post.id == postId);
  }

  @override
  Future<Post> updatePost(Post post) async {
    await _initialize();
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _posts.indexWhere((p) => p.id == post.id);
    if (index != -1) {
      _posts[index] = post;
    }
    return post;
  }
}
