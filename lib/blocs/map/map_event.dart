import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object> get props => [];
}

class LoadInitialLocation extends MapEvent {}

// Event used by _mapCreated function 
class MapCreated extends MapEvent {
  final GoogleMapController controller;

  MapCreated(this.controller);

  @override
  List<Object> get props => [controller];
}

// Event thats triggered when user presses Start button
class StartTrackingCurrentLocation extends MapEvent {}

// Event thats triggered when user inputs distance
class GenerateLoopRouteOptions extends MapEvent {
  final double distance;

  const GenerateLoopRouteOptions(this.distance);

  @override
  List<Object> get props => [distance];
}

class MapTrackingUpdate extends MapEvent {
  final LatLng initialPosition;
  final LatLng currentPosition;
  final Set<Polyline> polylines;
  final double selectedRouteDistance;

  MapTrackingUpdate({
    required this.currentPosition,
    required this.initialPosition,
    required this.polylines,
    required this.selectedRouteDistance
  });
}

// Event thats triggered when user presses Select button
class SelectRoute extends MapEvent {
  final List<LatLng> selectedRoute;

  const SelectRoute(this.selectedRoute);

  @override
  List<Object> get props => [selectedRoute];
}

// Event that triggers when user goes back from routedetails screen
class ResetMap extends MapEvent {}

