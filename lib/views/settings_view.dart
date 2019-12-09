import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:caio_bot/bloc/twitter_bot_orchestrator/bloc.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import '../auth.dart';

class SettingsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BotOrchestratorBloc, BotOrchestratorState>(builder: (BuildContext context, BotOrchestratorState state) {
      return Center(child: RaisedButton(onPressed: () async {
        final TwitterLoginResult result = await TwitterLogin(consumerKey: credentials['consumerKey'], consumerSecret: credentials['consumerSecret']).authorize();
        print(result.session.toMap());
      },),);
    });
  }
}