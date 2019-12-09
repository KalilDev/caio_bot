import 'dart:async';
import 'package:bloc/bloc.dart';
import './bloc.dart';
import '../authentication_mixin.dart';
import 'package:tweet_ui/models/api/tweet.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// There are some statistics that i want to keep for this bot and keep on the
/// state:
///
/// 1 - The id of every user the bot replied
///
/// 2 - The id of every tweet the bot replied
///
/// 3 - How many twitter api calls the bot made
///
/// 4 - The id of every reply the bot received
///
class BotOrchestratorBloc extends Bloc<BotOrchestratorEvent, BotOrchestratorState> with AuthenticationMixin {
  Future<void> _tick() async {
    await Future.delayed(Duration(minutes: 5));
    add(BotOrchestratorTick());
  }

  Future<String> getLastID() async {
    // Get from storage, if the bot ran before, and, if this is the first run,
    // get it from the network
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('lastTweetID');
    if (id == null) {
      // TODO: add this call to the stats
      final Response r = await authenticate().request('GET', 'statuses/user_timeline.json?screen_name=caiolucio54&count=5');
      final List<Tweet> tweets = (json.decode(r.body) as List).map((dynamic d)=>Tweet.fromJson(d as Map<String, dynamic>)).toList();
      final String last = tweets.last.idStr;
      prefs.setString('lastTweetID', last);
      id = last;
    }
    return id;
  }

  Future<String> getLatestID() async {
    // Get it from the network ALWAYS
    // TODO: add this call to the stats
    final Response r = await authenticate().request('GET', 'statuses/user_timeline.json?screen_name=caiolucio54&count=1');
    final List<Tweet> tweets = (json.decode(r.body) as List).map((dynamic d)=>Tweet.fromJson(d as Map<String, dynamic>)).toList();
    return tweets.first.idStr;
  }

  Future<List<Tweet>> getTweetsBetween(String first, String last) async {
    final List<Tweet> tweets = [];
    bool didHitLast = false;
    bool didHitFirst = false;
    // Break after 5 iterations to prevent a massive amount of api-calls
    int i = 0;
    while((!didHitFirst & !didHitLast) && i <= 5) {
      // TODO: add this calls to the stats
      final Response r = await authenticate().request('GET', 'statuses/user_timeline.json?screen_name=caiolucio54&count=10');
      final List<Tweet> newTweets = (json.decode(r.body) as List).map((dynamic d)=>Tweet.fromJson(d as Map<String, dynamic>)).toList();
      for (Tweet tweet in newTweets) {
        // Check if we hit the last ONLY if we didn't already
        if (!didHitLast & (tweet.idStr == last))
          didHitLast = true;

        // Only add the tweet if it is between the first and the last
        // i/e when didHitLast is true & didHitFirst is false.
        //
        // Because we set the bool before running this function, the last value
        // will be included, but not the first.
        if (didHitLast & !didHitFirst) {
          tweets.add(tweet);
        }

        // Check if we hit the first, then exit this for loop and the while loop
        if (tweet.idStr == first) {
          didHitFirst = true;
          break;
        }
      }
      i++;
    }

    return tweets;
  }

  List<String> processTweets(List<Tweet> tweets) {
    final List<String> processed = [];
    // This bot will only act in retweets. Every time our victim retweets
    // something, the bot will comment a message in the retweet.
    for (Tweet t in tweets) {
      if (t.isQuoteStatus) {
        // Time for action
        processed.add(t.idStr);
      }
    }
    return processed;
  }

  Future<void> sendTweets(List<String> tgtTweets) async {
    for (String tweet in tgtTweets) {
      // Post this tweet
      final Response r = await authenticate().request('POST', 'statuses/update.json?status=chacota&auto_populate_reply_metadata=true&in_reply_to_status_id='+tweet);
    }
  }

  Future<void> _scheduledAction() async {
    // On start we need to do a couple of things:
    //
    // Firstly we need to check what was the last looked up tweet from the
    // victim, or, if this is the first run, get one tweet to be the first.
    //
    // Secondly, we need to check the non-processed tweets between the last
    // one and the latest one.
    //
    // Then, we need to run the processing on all these tweets
    //
    // And, lastly, now that we are in a state where there are no pending ops,
    // we start the ticker to re-try this from time to time.
    final String lastTweetID = await getLastID();
    final String latestTweetID = await getLatestID();
    if (latestTweetID != lastTweetID) {
      final List<Tweet> nonProcessedTweets = await getTweetsBetween(lastTweetID, latestTweetID);
      final List<String> pending = processTweets(nonProcessedTweets);
      return add(BotOrchestratorUpdate(pending: pending, lastTweet: latestTweetID));
    }
    add(BotOrchestratorUpdate(lastTweet: latestTweetID));
  }

  Future<void> saveLastState(String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('lastTweetID', id);
  }

  @override
  BotOrchestratorState get initialState {
    _scheduledAction();
    return InitialBotOrchestratorState();
  }

  @override
  Stream<BotOrchestratorState> mapEventToState(
    BotOrchestratorEvent event,
  ) async* {
    if (event is BotOrchestratorTick) {
      _scheduledAction();
    }
    if (event is BotOrchestratorUpdate) {
      if (!(event.pending == null || event.pending.isEmpty)) {
        // We need to send these tweets!
        await sendTweets(event.pending);
      }
      // Ok, now we store the last tweet for future reference
      saveLastState(event.lastTweet);
      // Start the ticker to repeat the schedule every 10 seconds
      _tick();
      yield RunningBotOrchestratorState();
    }
  }
}
