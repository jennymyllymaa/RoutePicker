import 'package:bloc/bloc.dart';
import 'dart:async';
import 'package:routepicker/blocs/stopwatch/stopwatch_event.dart';
import 'package:routepicker/blocs/stopwatch/stopwatch_state.dart';

class StopwatchBloc extends Bloc<StopwatchEvent, StopwatchState> {
  final _stopwatch = Stopwatch();
  Timer? _timer;

  //Initialize the stopwatch with duration.zero
  StopwatchBloc() : super(const StopwatchInitial(Duration.zero)) {
    on<StartStopwatch>(_onStartStopwatch);
    on<StopStopwatch>(_onStopStopwatch);
    on<ResetStopwatch>(_onResetStopwatch);
    on<AddOneSecond>(_addOneSecond);
  }

  //Function that adds a second given that stopwatch is running
  Future<void> _addOneSecond(AddOneSecond event, Emitter<StopwatchState> emit) async {
    if (state is StopwatchRunning) {
      emit(StopwatchRunning(_stopwatch.elapsed));
    }
  }

  //Triggers on the start button, uses AddOneSecond event every second and emit triggers the "state change"
  Future<void> _onStartStopwatch(StartStopwatch event, Emitter<StopwatchState> emit) async {
    _stopwatch.start();
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      add(AddOneSecond());
    });
    emit(StopwatchRunning(_stopwatch.elapsed));
  }

  void _onStopStopwatch(StopStopwatch event, Emitter<StopwatchState> emit) {
    _stopwatch.stop();
    _timer?.cancel();
    emit(StopwatchStopped(_stopwatch.elapsed));
  }

  void _onResetStopwatch(ResetStopwatch event, Emitter<StopwatchState> emit) {
    _stopwatch.reset();
    emit(const StopwatchInitial(Duration.zero));
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
