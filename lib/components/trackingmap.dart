import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:routepicker/blocs/map/map_bloc.dart';
import 'package:routepicker/blocs/map/map_event.dart';
import 'package:routepicker/blocs/map/map_state.dart';

class TrackingMap extends StatefulWidget {
  const TrackingMap({super.key});

  @override
  State<TrackingMap> createState() => _TrackingMapState();
}

class _TrackingMapState extends State<TrackingMap> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapBloc, MapState>(
      builder: (context, state) {
        if (state is MapInitial || state is MapLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is MapLoaded) {
          return GoogleMap(
            onMapCreated: (GoogleMapController controller) {
                context.read<MapBloc>().add(MapCreated(controller));
              },
            initialCameraPosition: CameraPosition(
              target: state.currentPosition,
              zoom: 15.0,
            ),
            markers: {
              Marker(
                markerId: const MarkerId("_initialLocation"),
                icon: BitmapDescriptor.defaultMarker,
                position: state.initialPosition,
              ),
            },
            polylines: state.polylines,
          );
        } else if (state is MapTracking) {
          return GoogleMap(
            onMapCreated: (GoogleMapController controller) {
                context.read<MapBloc>().add(MapCreated(controller));
              },
            initialCameraPosition: CameraPosition(
              target: state.initialPosition,
              zoom: 15.0,
            ),
            markers: {
              Marker(
                markerId: const MarkerId("_initialLocation"),
                icon: BitmapDescriptor.defaultMarker,
                position: state.initialPosition,
              ),
              Marker(
              markerId: const MarkerId("_currentLocation"),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
              position: state.currentPosition,
              ),
            },
            polylines: state.polylines,
          );
        } else if (state is MapError) {
          return Center(child: Text(state.message));
        } else {
          return const Center(child: Text("Unknown state"));
        }
      },
    );
  }
}
