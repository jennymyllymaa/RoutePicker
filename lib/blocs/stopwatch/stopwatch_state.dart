import 'package:equatable/equatable.dart';

abstract class StopwatchState extends Equatable {
  final Duration duration;
  const StopwatchState(this.duration);

  @override
  List<Object> get props => [];
}

// State when the stopwatch hasnt been started yet
class StopwatchInitial extends StopwatchState {
  const StopwatchInitial(super.duration);

  @override
  List<Object> get props => [duration];
}

// State when stopwatch is running
class StopwatchRunning extends StopwatchState {
  const StopwatchRunning(super.duration);

  @override
  List<Object> get props => [duration];
}

// State when stopwatch is paused
class StopwatchPaused extends StopwatchState {
  const StopwatchPaused(super.duration);

  @override
  List<Object> get props => [duration];
}

// State when stopwatch is stopped
class StopwatchStopped extends StopwatchState {
  const StopwatchStopped(super.duration);

  @override
  List<Object> get props => [duration];
}
