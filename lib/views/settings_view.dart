import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:caio_bot/bloc/twitter_bot_orchestrator/bloc.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';

class SettingsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BotOrchestratorBloc, BotOrchestratorState>(builder: (BuildContext context, BotOrchestratorState state) {
      return Center(child: RaisedButton(onPressed: () async {
        final TwitterLoginResult result = await TwitterLogin(consumerKey: "yuido7C5UTc7eKbwx9NmaS02L", consumerSecret: "Z43ykEay1VU3y7LjN7CuqcAy6aaAn1qE28hpXiXXSYEHP8eSt7").authorize();
        print(result.session.toMap());
      },),);
    });
  }
}