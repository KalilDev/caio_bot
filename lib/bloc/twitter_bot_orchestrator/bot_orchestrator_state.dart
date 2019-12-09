import 'package:meta/meta.dart';

@immutable
abstract class BotOrchestratorState {}

class InitialBotOrchestratorState extends BotOrchestratorState {}
class RunningBotOrchestratorState extends BotOrchestratorState {}
class PausedBotOrchestratorState extends BotOrchestratorState {}
