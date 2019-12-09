import 'package:flutter/material.dart';
import 'package:tweet_ui/tweet_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:caio_bot/bloc/twitter_feed_manager/bloc.dart';

class FeedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedManagerBloc, FeedManagerState>(builder: (BuildContext context, FeedManagerState state) {
      if (state is LoadedFeedManagerState) {
        return RefreshIndicator(
          onRefresh: ()async =>BlocProvider.of<FeedManagerBloc>(context).add(UpdateFeedEvent()),
          child: ListView.builder(itemBuilder: (BuildContext context, int i) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: CompactTweetView.fromTweet(state.tweets[i]),
            );
          }, itemCount: state.tweets.length,),
        );
      }
      return Center(child: CircularProgressIndicator(),);
    });
  }
}