import 'package:meta/meta.dart';
import 'package:tweet_ui/models/api/tweet.dart';

@immutable
abstract class FeedManagerState {}

class LoadingFeedManagerState extends FeedManagerState {}
class LoadedFeedManagerState extends FeedManagerState {
  LoadedFeedManagerState(this.tweets);
  final List<Tweet> tweets;
}
