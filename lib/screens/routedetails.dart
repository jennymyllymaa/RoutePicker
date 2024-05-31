import 'package:flutter/material.dart';
import 'package:routepicker/blocs/stopwatch/stopwatch_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routepicker/blocs/map/map_bloc.dart';
import 'package:routepicker/blocs/map/map_state.dart';
import 'package:routepicker/blocs/map/map_event.dart';
import 'package:routepicker/components/trackingmap.dart';
import 'package:routepicker/components/stopwatch.dart';
import 'package:routepicker/blocs/stopwatch/stopwatch_bloc.dart';
import 'package:routepicker/blocs/stopwatch/stopwatch_event.dart';
import 'package:routepicker/screens/mainscreen.dart';
import 'package:routepicker/blocs/settings/settings_bloc.dart';

class RouteDetailScreen extends StatefulWidget {
  const RouteDetailScreen({Key? key}) : super(key: key);

  @override
  State<RouteDetailScreen> createState() => _RouteDetailScreenState();
}

class _RouteDetailScreenState extends State<RouteDetailScreen> {
  final SettingsBloc _settingsBloc = SettingsBloc(); 
  double? _weight;

  @override
  void initState() {
    super.initState();
    _settingsBloc.getSavedWeight().then((value) {
      setState(() {
        _weight = value;
      });
    });
  }

  String calculateCalories(double distanceInMeters) {
  if (_weight != null) {
    double cal = (distanceInMeters / 1000) * _weight! * 0.53;
    return cal.toStringAsFixed(2);
  } else {
    return "No weight saved."; // Default value or handle case where weight is not available
  }
}

  @override
  Widget build(BuildContext context) {
    return PopScope( //Backing had to be done manually, dispose gave errors
      canPop: false,
      onPopInvoked : (didPop){
        context.read<MapBloc>().add(ResetMap());
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MainScreen(),
          ),
        );
      },
      child: Scaffold(
      appBar: AppBar(
        title: const Text('Route Details'),
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: BlocProvider.of<MapBloc>(context)),
          BlocProvider.value(value: BlocProvider.of<StopwatchBloc>(context)),
        ],
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<MapBloc, MapState>(
                builder: (context, mapState) {
                  if (mapState is MapLoaded || mapState is MapTracking) {
                    return TrackingMap(); 
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BlocBuilder<StopwatchBloc, StopwatchState>(
                    builder: (context, stopwatchState) {
                      return StopwatchView(); 
                    },
                  ),
                  const SizedBox(height: 10),
                  BlocBuilder<MapBloc, MapState>(
                    builder: (context, mapState) {
                      if (mapState is MapLoaded) {
                        return Column(
                          children: [
                            Text('Total Distance: ${mapState.selectedRouteDistance.toStringAsFixed(2)} meters'),
                            const SizedBox(height: 10),
                            Text('Estimated calorie burn: ${calculateCalories(mapState.selectedRouteDistance)}  kcal'),
                          ],
                        );
                      }
                      if (mapState is MapTracking) {
                        return Column(
                          children: [
                            Text('Total Distance: ${mapState.selectedRouteDistance.toStringAsFixed(2)} meters'),
                            const SizedBox(height: 10),
                            Text('Estimated calorie burn: ${calculateCalories(mapState.selectedRouteDistance)} kcal'),
                          ],
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  BlocBuilder<StopwatchBloc, StopwatchState>(
                    builder: (context, stopwatchState) {
                      if (stopwatchState is StopwatchInitial) {
                        return ElevatedButton(
                          onPressed: () {
                            context.read<StopwatchBloc>().add(const StartStopwatch());
                            context.read<MapBloc>().add(StartTrackingCurrentLocation());
                          },
                          child: const Text('Start'),
                        );
                      }
                      else if (stopwatchState is StopwatchRunning) {
                        return ElevatedButton(
                          onPressed: () {
                            context.read<StopwatchBloc>().add(const StopStopwatch());
                          },
                          child: const Text('Stop'),
                        );
                      }
                      else if (stopwatchState is StopwatchStopped) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                context.read<StopwatchBloc>().add(const StartStopwatch());
                              },
                              child: const Text('Resume'),
                            ),
                            const SizedBox(width: 16.0),
                            ElevatedButton(
                              onPressed: () {
                                context.read<StopwatchBloc>().add(const ResetStopwatch());
                              },
                              child: const Text('Reset'),
                            ),
                        ],);
                      }
                      else {
                        return const Text("Stopwatch state error"); //Cant work without an else
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
