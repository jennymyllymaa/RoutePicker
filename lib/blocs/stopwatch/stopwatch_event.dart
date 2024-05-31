import 'package:equatable/equatable.dart';

abstract class StopwatchEvent extends Equatable {
  const StopwatchEvent();

  @override
  List<Object> get props => [];
}

class LoadInitialStopwatch extends StopwatchEvent {}

class StartStopwatch extends StopwatchEvent {
  const StartStopwatch();

  @override
  List<Object> get props => [];
}

class StopStopwatch extends StopwatchEvent {
  const StopStopwatch();

  @override
  List<Object> get props => [];
}

class ResetStopwatch extends StopwatchEvent {
  const ResetStopwatch();

  @override
  List<Object> get props => [];
}

class AddOneSecond extends StopwatchEvent {
  const AddOneSecond();

  @override
  List<Object> get props => [];
}
