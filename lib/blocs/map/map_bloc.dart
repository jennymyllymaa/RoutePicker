import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'dart:math' as Math;
import 'dart:async';
import 'package:routepicker/blocs/map/map_event.dart';
import 'package:routepicker/blocs/map/map_state.dart';
import 'package:routepicker/constants.dart';
import 'dart:io' show Platform;
import 'package:geocoding/geocoding.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final location.Location _locationController = location.Location();
  LatLng? _initialPosition;
  LatLng? _currentPosition;
  String _initialAddress = "";
  String _initialPostalInfo = "";
  Set<Polyline>? _polylines;
  double _selectedRouteDistance = 0.0;
  GoogleMapController? _mapController; //for the camera animate (in user tracking)
  // Completer<GoogleMapController> mapCompleter = Completer<GoogleMapController>(); //
  // //Completer<GoogleMapController> _mapControllerCompleter = Completer<GoogleMapController>();
  List<double> _routeDistances = [];

  MapBloc() : super(MapInitial()) {
    on<LoadInitialLocation>(_onLoadInitialLocation);
    on<GenerateLoopRouteOptions>(_onGenerateLoopRouteOptions);
    on<SelectRoute>(_onSelectRoute);
    on<StartTrackingCurrentLocation>(_onLoadCurrentLocation);
    // on<CenterCamera>(_onCenterCamera);
    on<MapCreated>(_onMapCreated);
    on<ResetMap>(_onResetMap);
    on<MapTrackingUpdate>(_onMapTrackingUpdate);
  }

  void _onMapCreated(MapCreated event, Emitter<MapState> emit) {
    _mapController = event.controller;
  }

  void _onResetMap(ResetMap event, Emitter<MapState> emit) {
    emit(MapInitial());
  }

  Future<void> _onLoadCurrentLocation(StartTrackingCurrentLocation event, Emitter<MapState> emit) async {
    print("onloadcurrentlocation kutsuttu");
    emit(MapLoading());
    try {
      print("TRY");
      await _getUpdatedLocation(emit);
    } catch (e) {
      emit(MapError(e.toString()));
    }
  }

  Future<void> _onLoadInitialLocation(LoadInitialLocation event, Emitter<MapState> emit) async {
    print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! onloadinitiallocation kutsuttu");
    emit(MapLoading());
    try {
      await _getInitialLocation();
      if (_initialPosition != null) {
        emit(MapLoaded(
        initialPosition: _initialPosition!,
        initialAddress: _initialAddress,
        initialPostalInfo: _initialPostalInfo,
        currentPosition: _initialPosition!,
        polylines: Set<Polyline>(),
        routeOptions: [],
        selectedRouteDistance: 0.0,
        routeDistances: _routeDistances
        ));
      } 
    } catch (e) {
      emit(MapError(e.toString()));
    }
  }

  Future<void> _getInitialLocation() async {
    bool _serviceEnabled;
    location.PermissionStatus _permissionsGranted;
    print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! getinitiallocation kutsuttu");

    _serviceEnabled = await _locationController.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
      if (!_serviceEnabled) {
        throw Exception("Service not enabled");
      }
    }

    _permissionsGranted = await _locationController.hasPermission();
    if (_permissionsGranted == location.PermissionStatus.denied) {
      _permissionsGranted = await _locationController.requestPermission();
      if (_permissionsGranted != location.PermissionStatus.granted) {
        throw Exception("Permission not granted");
      }
    }

    location.LocationData? initialLocation = await _locationController.getLocation();
    if (initialLocation != null) {
      _initialPosition = LatLng(initialLocation.latitude!, initialLocation.longitude!);
      await _getAddressFromLatLng();
    }
  }

  Future<void> _getAddressFromLatLng() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        _initialPosition!.latitude,
        _initialPosition!.longitude,
      );

      Placemark place = placemarks[0];
      _initialAddress = "${place.thoroughfare} ${place.subThoroughfare}";
      _initialPostalInfo = "${place.locality}, ${place.administrativeArea} ${place.postalCode}, ${place.country}";
    } catch (e) {
      throw Exception("Error getting address: $e");
    }
  }

  // Future<void> centerCamera(LatLng position) async {
  //   CameraPosition newCameraPosition = CameraPosition(target: position, zoom: 15.0);
  //   if (_mapController != null) {
  //     await _mapController!.animateCamera(CameraUpdate.newCameraPosition(newCameraPosition)); //tää jumittaa jos käyttää 
  //   }
  // }

  void _onMapTrackingUpdate(MapTrackingUpdate event, Emitter<MapState> emit) {
    emit(MapTracking(
      initialPosition: event.initialPosition,
      currentPosition: event.currentPosition,
      polylines: event.polylines,
      selectedRouteDistance: event.selectedRouteDistance,
    ));
    // centerCamera(event.currentPosition);
  }

  Future<void> _getUpdatedLocation(Emitter<MapState> emit) async {
    print("_getUpdatedLocation: Start");
    _locationController.onLocationChanged.listen((location.LocationData currentLocation) {
      if (currentLocation.latitude != null && currentLocation.longitude != null) {
        _currentPosition = LatLng(currentLocation.latitude!, currentLocation.longitude!);
        print("getUpdatedLocation: Received location update - $_currentPosition");

        if (_initialPosition != null && _currentPosition != null) {
          print("gonna emit");
          print("_initialPosition: $_initialPosition  _currentPosition: $_currentPosition  _polylines: $_polylines  _selectedRouteDistance: $_selectedRouteDistance");
          
          add(MapTrackingUpdate(
            initialPosition: _initialPosition!,
            currentPosition: _currentPosition!,
            polylines: _polylines!,
            selectedRouteDistance: _selectedRouteDistance,
          ));
        }
      }
      print("getUpdatedLocation: Current position - $_currentPosition");
    });
    print("getUpdatedLocation: End");
  }

  Future<void> _onGenerateLoopRouteOptions(GenerateLoopRouteOptions event, Emitter<MapState> emit,) async {
    emit(MapLoading());
    if (_initialPosition == null) return;

    List<List<LatLng>> options = [];
    List<double> routeDistances = [];

    for (int i = 0; i < 6; i++) {
      double bearing = (i * 60).toDouble();
      double midPointDistance = event.distance / 2;
      LatLng midPoint = _calculateMidPoint(_initialPosition!, midPointDistance, bearing);

      List<LatLng> outwardRoute = await _getRouteBetweenPoints(_initialPosition!, midPoint);
      List<LatLng> returnRoute = await _getRouteBetweenPoints(midPoint, _initialPosition!);
      List<LatLng> loopRoute = outwardRoute + returnRoute;

      options.add(loopRoute);
      _routeDistances.add(_calculateRouteDistance(loopRoute));
    }

    emit(MapLoaded(
      initialPosition: _initialPosition!,
      initialAddress: _initialAddress,
      initialPostalInfo: _initialPostalInfo,
      currentPosition: _initialPosition!,
      polylines: Set<Polyline>(),
      routeOptions: options,
      selectedRouteDistance: 0.0,
      routeDistances: _routeDistances
    ));
  }

  Future<void> _onSelectRoute(SelectRoute event, Emitter<MapState> emit) async {
  double totalDistance = _calculateRouteDistance(event.selectedRoute);
  Polyline polyline = Polyline(
    polylineId: PolylineId("selectedRoute"),
    color: Colors.red,
    points: event.selectedRoute,
    width: 8,
  );

  // Emit a new MapLoaded state with both the selected route and existing route options
  emit(MapLoaded(
    initialPosition: _initialPosition!,
    initialAddress: _initialAddress,
    initialPostalInfo: _initialPostalInfo,
    currentPosition: _initialPosition!,
    polylines: {polyline}, 
    routeOptions: (state as MapLoaded).routeOptions, 
    selectedRouteDistance: totalDistance,
    routeDistances: _routeDistances,
    selectedRouteIndex: (state as MapLoaded).routeOptions.indexOf(event.selectedRoute)
  ));

  //So that MapTracking state can use these
  _polylines = {polyline};
  _selectedRouteDistance = totalDistance;
  print((state as MapLoaded).routeOptions.indexOf(event.selectedRoute));
}

  LatLng _calculateMidPoint(LatLng start, double distance, double bearing) {
    double distanceRad = distance / 6371000;
    double bearingRad = bearing * (Math.pi / 180);
    double startLatRad = start.latitude * (Math.pi / 180);
    double startLngRad = start.longitude * (Math.pi / 180);

    double midLatRad = Math.asin(Math.sin(startLatRad) * Math.cos(distanceRad) + Math.cos(startLatRad) * Math.sin(distanceRad) * Math.cos(bearingRad));
    double midLngRad = startLngRad + Math.atan2(Math.sin(bearingRad) * Math.sin(distanceRad) * Math.cos(startLatRad), Math.cos(distanceRad) - Math.sin(startLatRad) * Math.sin(midLatRad));

    double midLat = midLatRad * (180 / Math.pi);
    double midLng = midLngRad * (180 / Math.pi);

    return LatLng(midLat, midLng);
  }

  Future<List<LatLng>> _getRouteBetweenPoints(LatLng start, LatLng end) async {
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      getGoogleApiKey(),
      PointLatLng(start.latitude, start.longitude),
      PointLatLng(end.latitude, end.longitude),
      travelMode: TravelMode.walking,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
    return polylineCoordinates;
  }

  double _calculateRouteDistance(List<LatLng> route) {
    double totalDistance = 0.0;

    for (int i = 0; i < route.length - 1; i++) {
      totalDistance += _getStraightLineDistance(
        route[i].latitude,
        route[i].longitude,
        route[i + 1].latitude,
        route[i + 1].longitude,
      );
    }
    return totalDistance;
  }

  double _getStraightLineDistance(double lat1, double lon1, double lat2, double lon2) {
    const double R = 6371000; // Radius of the earth in meters
    double dLat = _deg2rad(lat2 - lat1);
    double dLon = _deg2rad(lon2 - lon1);
    double a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
        Math.cos(_deg2rad(lat1)) * Math.cos(_deg2rad(lat2)) *
        Math.sin(dLon / 2) * Math.sin(dLon / 2);
    double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    double distance = R * c; // Distance in meters
    return distance;
  }

  double _deg2rad(double deg) {
    return deg * (Math.pi / 180);
  }

  String getGoogleApiKey() {
    if (Platform.isAndroid) {
      return googleApiKeyAndroid;
    } else if (Platform.isIOS) {
      return googleApiKeyiOS;
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}
