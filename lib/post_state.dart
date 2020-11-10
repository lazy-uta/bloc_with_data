import 'package:bloc_with_data/post.dart';
import 'package:equatable/equatable.dart';

abstract class PostState extends Equatable{
  PostState([List posts = const []]) : super(posts);

  copyWith({bool hasReachedMax}) {}
}

class PostUninitialized extends PostState{
  @override
  String toString() => 'PostUinitialized';
}

class PostEror extends PostState{
  @override
  String toString() => 'PostError';
}

class PostLoaded extends PostState{
  final List<Post> posts;
  final bool hasReachedMax;

  PostLoaded({
    this.posts,
    this.hasReachedMax
  }) : super([posts, hasReachedMax]);

  PostLoaded copyWith({
    List<Post> posts,
    bool hasReachedMax,
  }){
    return PostLoaded(
      posts: posts ?? this.posts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() => 'PostLoaded { posts : ${posts.length} , hasReachedMax: $hasReachedMax}';
}