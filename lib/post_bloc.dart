import 'dart:convert';

import 'package:bloc_with_data/post.dart';
import 'package:bloc_with_data/post_event.dart';
import 'package:bloc_with_data/post_state.dart';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;

class PostBloc extends Bloc<PostEvent, PostState>{
  final http.Client httpClient;

  PostBloc({this.httpClient});

  @override
  // TODO: implement initialState
  PostState get initialState => PostUninitialized(); 

  @override
  Stream<PostState> mapEventToState(PostEvent event) async* {
    if(event is Fetch && !_hasReachedMax(currentState)){
      try{
        if(currentState is PostUninitialized){
          final posts = await _fetchPost(0, 20);
          yield PostLoaded(hasReachedMax: false, posts: posts);
        }
        if(currentState is PostLoaded){
          final posts = await _fetchPost(currentState.props.length,  20);
          yield posts.isEmpty
          ? currentState.copyWith(hasReachedMax: true)
          : PostLoaded(
            posts: currentState.props + posts , hasReachedMax: false
          );
        }
      }
      catch(_){
        yield PostEror();
      }
    }
  }

  bool _hasReachedMax(PostState state) => 
  state is PostLoaded && state.hasReachedMax;

  Future<List<Post>> _fetchPost(int starIndex, int limit)async {
    final response = await httpClient.get(
      'https://jsonplaceholder.typicode.com/posts?_start=$starIndex&_limit=$limit');
      if(response.statusCode == 200){
        final data = json.decode(response.body) as List;
        return data.map((rawPost) {
          return Post(
            id: rawPost['id'],
            title: rawPost['title'],
            body: rawPost['body']
          );
        }).toList();

      }else{
        throw Exception('Error fetching Data');
      }
  }

}

