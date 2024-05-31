import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class MapState extends Equatable {
  const MapState();

  @override
  List<Object> get props => [];
}

// State of the initial map
class MapInitial extends MapState {}

// State of the map when loading from api
class MapLoading extends MapState {}

// State when map is ready
class MapLoaded extends MapState {
  final LatLng initialPosition;
  final String initialAddress;
  final String initialPostalInfo;
  final LatLng currentPosition;
  final Set<Polyline> polylines;
  final List<List<LatLng>> routeOptions;
  final double selectedRouteDistance;
  final List<double> routeDistances; 
  final int? selectedRouteIndex; //

  const MapLoaded({
    required this.initialPosition,
    required this.initialAddress,
    required this.initialPostalInfo,
    required this.currentPosition,
    required this.polylines,
    required this.routeOptions,
    required this.selectedRouteDistance,
    required this.routeDistances ,
    this.selectedRouteIndex //
  });

  @override
  List<Object> get props => [
    initialPosition,
    initialAddress,
    initialPostalInfo,
    currentPosition,
    polylines,
    routeOptions,
    selectedRouteDistance,
  ];
}

// State of the map for routedetails screen when timer and currentlocation is on
class MapTracking extends MapState {
  final LatLng initialPosition;
  final LatLng currentPosition;
  final Set<Polyline> polylines;
  final double selectedRouteDistance;

  const MapTracking({
    required this.initialPosition,
    required this.currentPosition,
    required this.polylines,
    required this.selectedRouteDistance,
  });

  @override
  List<Object> get props => [
    initialPosition,
    currentPosition,
    polylines,
    selectedRouteDistance,
  ];
}

// State when loading errored
class MapError extends MapState {
  final String message;

  const MapError(this.message);

  @override
  List<Object> get props => [message];
}
