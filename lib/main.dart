import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/twitter_feed_manager/feed_manager_bloc.dart';
import 'bloc/twitter_bot_orchestrator/bot_orchestrator_bloc.dart';
import 'views/feed_page.dart';
import 'views/new_tweet_view.dart';
import 'views/settings_view.dart';
import 'widgets/material_compliant_transition.dart';
import 'widgets/navbar.dart';
import 'widgets/navigation_entry.dart';

void main() => runApp(BlocProvider(create: (_)=>FeedManagerBloc(), child: BlocProvider(create: (_)=>BotOrchestratorBloc(), child: MyApp())));

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        'new': (BuildContext context) => NewTweetView(),
      },
      home: AppRoot(),
    );
  }
}

class AppRoot extends StatefulWidget {
  AppRoot({Key key}) : super(key: key);

  @override
  _AppRootState createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  int currentPage = 0;
  final List<Widget> pages = [
    FeedPage(),
    SettingsView()
  ];

  _navigateToNew() {
    Navigator.of(context).pushNamed('new');
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Bot do Caio fodase'),
      ),
      bottomNavigationBar: BottomBeautifulNavBar(
        entries: kAppEntries, index: currentPage,onChanged: (int i)=>setState(()=>currentPage=i),),
      body: MaterialAnimatedSwitcher(child: pages[currentPage]),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      extendBody: true,
      floatingActionButton: currentPage == 0 ? FloatingActionButton(
        onPressed: _navigateToNew,
        tooltip: 'Novo Tuite',
        child: Icon(Icons.add),
      ) : null, // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
