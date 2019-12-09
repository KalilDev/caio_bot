import 'package:meta/meta.dart';
import 'package:tweet_ui/models/api/tweet.dart';

@immutable
abstract class FeedManagerEvent {}

class LoadedTweets extends FeedManagerEvent {
  LoadedTweets(this.tweets);
  final List<Tweet> tweets;
}

class UpdateFeedEvent extends FeedManagerEvent {}