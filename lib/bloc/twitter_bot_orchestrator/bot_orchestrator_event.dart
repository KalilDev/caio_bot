import 'package:meta/meta.dart';

@immutable
abstract class BotOrchestratorEvent {}
class BotOrchestratorTick extends BotOrchestratorEvent {}
class BotOrchestratorUpdate extends BotOrchestratorEvent {
  BotOrchestratorUpdate({this.pending, @required this.lastTweet});
  final List<String> pending;
  final String lastTweet;
}
