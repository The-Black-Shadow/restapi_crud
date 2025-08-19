import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restapi_crud/domain/repositories/post_repository.dart';
import 'package:restapi_crud/presentation/bloc/post_bloc.dart';
import 'package:restapi_crud/presentation/ui/screens/post_list_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostBloc(postRepository: PostRepository()),
      child: MaterialApp(
        title: 'Flutter CRUD MockAPI',
        theme: ThemeData(
          primarySwatch: Colors.teal,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const PostListScreen(),
      ),
    );
  }
}

