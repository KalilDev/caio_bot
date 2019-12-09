import 'dart:async';
import 'package:bloc/bloc.dart';
import './bloc.dart';
import '../authentication_mixin.dart';
import 'package:tweet_ui/models/api/tweet.dart';
import 'package:http/http.dart';
import 'dart:convert';

class FeedManagerBloc extends Bloc<FeedManagerEvent, FeedManagerState> with AuthenticationMixin {
  Future<void> _reload() async {
    final Response r = await authenticate().request("GET", "statuses/home_timeline.json");
    add(LoadedTweets((json.decode(r.body) as List).map((dynamic d)=>Tweet.fromJson(d as Map<String, dynamic>)).toList()));
  }
  
  @override
  FeedManagerState get initialState {
    _reload();
    return LoadingFeedManagerState();
  }

  @override
  Stream<FeedManagerState> mapEventToState(
    FeedManagerEvent event,
  ) async* {
    if (event is LoadedTweets) {
      yield LoadedFeedManagerState(event.tweets);
    }
    if (event is UpdateFeedEvent) {
      _reload();
      yield LoadingFeedManagerState();
    }
  }
}
