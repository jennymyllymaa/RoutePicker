import 'package:flutter/material.dart';
import 'package:routepicker/blocs/map/map_bloc.dart';
import 'package:routepicker/blocs/map/map_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class RouteOption extends StatelessWidget {
  final int index;
  final List<List<LatLng>> routeOptions;
  final double routeDistance;
  final bool isSelected;

  const RouteOption({
    Key? key,
    required this.index,
    required this.routeOptions,
    required this.routeDistance,
    required this.isSelected
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("Route option ${index + 1}    ( ${routeDistance.toStringAsFixed(2)} m )"), 
      // trailing: Icon(Icons.run_circle),
      trailing: Icon(Icons.directions_run, color: isSelected ? Colors.blue : Colors.black),
      onTap: () {
        context.read<MapBloc>().add(SelectRoute(routeOptions[index]));
      },
    );
  }
}