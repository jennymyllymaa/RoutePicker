import 'package:flutter/material.dart';
import 'package:routepicker/theme/theme.dart';
import 'package:routepicker/screens/mainscreen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routepicker/blocs/map/map_bloc.dart';
import 'package:routepicker/blocs/stopwatch/stopwatch_bloc.dart';
      
void main() {
  runApp(const RouteApp());
}

class RouteApp extends StatelessWidget {
  const RouteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MapBloc>(
          create: (context) => MapBloc(),
        ),
        BlocProvider<StopwatchBloc>(
          create: (context) => StopwatchBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'Route Picker',
        debugShowCheckedModeBanner: false,
        theme: getLightTheme(),
        darkTheme: getDarkTheme(),
        home: const MainScreen(),
      ),
    );
  }
}

