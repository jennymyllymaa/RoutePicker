import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routepicker/blocs/stopwatch/stopwatch_bloc.dart';
import 'package:routepicker/blocs/stopwatch/stopwatch_state.dart';

class StopwatchWidget extends StatelessWidget {
  const StopwatchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StopwatchBloc(),
      child: StopwatchView(),
    );
  }
}

class StopwatchView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: 
        BlocBuilder<StopwatchBloc, StopwatchState>(
          builder: (context, state) {
            //State duration is zero if state is StopwatchStopped (not ticking), but for other
            // states its same. This might be better to write somehow else but there were errors
            final duration = state is StopwatchInitial  
                ? state.duration
                : state is StopwatchRunning
                    ? state.duration
                    : state is StopwatchPaused
                        ? state.duration
                        : state is StopwatchStopped
                            ? state.duration
                            : Duration.zero;
            final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
            final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
            return Text(
              '$minutes:$seconds',
              style: const TextStyle(fontSize: 48.0),
            );
          },
        ), 
    );
  }
}
