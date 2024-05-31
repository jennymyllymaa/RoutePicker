import 'package:flutter/material.dart';
import 'package:routepicker/screens/settings.dart';
import 'package:routepicker/theme/theme.dart';
import 'package:routepicker/components/map.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routepicker/blocs/map/map_bloc.dart';
import 'package:routepicker/blocs/map/map_state.dart';
import 'package:routepicker/blocs/map/map_event.dart';
import 'package:routepicker/screens/routedetails.dart';
import 'package:routepicker/blocs/stopwatch/stopwatch_bloc.dart';
import 'package:routepicker/components/routeoption.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

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
      child: MaterialApp( // for some reason if this is for example scaffold the trackingmap never loads
        debugShowCheckedModeBanner: false,
        theme: getLightTheme(),
        darkTheme: getDarkTheme(),
        home: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: AppBar(
            title: const Text("RoutePicker"),
            elevation: 2,
          ),
          drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const SizedBox(
                    height: 100.0,
                    child: DrawerHeader(
                        child: Text('RoutePicker'),
                      ),
                  ),
                  ListTile(
                    title: const Text('Settings'),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => SettingsScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          body: BlocConsumer<MapBloc, MapState>(
            listener: (context, state) {
              if (state is MapError) {
                Text(state.message);
              }
            },
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: 'Enter distance in meters',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      onSubmitted: (value) {
                        double distance = double.parse(value);
                        context.read<MapBloc>().add(GenerateLoopRouteOptions(distance));
                      },
                    ),
                  ),
                  const Expanded(
                    child: MyMap(),
                  ),
                  if (state is MapLoaded)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(state.initialAddress),
                          Text(state.initialPostalInfo),
                          // if (state.routeOptions.isNotEmpty)
                          const SizedBox(height: 10),
                          // Text("Selected Route Distance: ${state.selectedRouteDistance.toStringAsFixed(2)} m"),
                        ],
                      ),
                    ),
                  if (state is MapLoaded && state.routeOptions.isNotEmpty)
                    Column(
                      children: [
                        Container(
                          height: 150,
                          child: ListView.builder(
                            itemCount: state.routeOptions.length,
                            itemBuilder: (context, index) {
                              return RouteOption(index: index, routeOptions: state.routeOptions, routeDistance: state.routeDistances[index], isSelected: state.selectedRouteIndex == index);
                            },
                          ),
                        ),
                        if (state.routeOptions.isNotEmpty)
                          const SizedBox(height: 20),
                          ElevatedButton(
                            child: Text("Select"),
                            onPressed: () => {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RouteDetailScreen(
                                  ),
                                ),
                              )
                            }),
                          const SizedBox(height: 20),
                      ],
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:routepicker/theme/theme.dart';
// import 'package:routepicker/components/map.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:routepicker/blocs/map/map_bloc.dart';
// import 'package:routepicker/blocs/map/map_state.dart';
// import 'package:routepicker/blocs/map/map_event.dart';
// import 'package:routepicker/screens/routedetails.dart';

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   String _address = '';
//   String _postalInfo = '';

//   void _updateAddress(String addressInfo) {
//     setState(() {
//       List address = addressInfo.split(";");
//       _address = address[0];
//       _postalInfo = address[1];
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider<MapBloc>(
//           create: (context) => MapBloc(),
//         ),
//       ],
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         theme: getLightTheme(),
//         darkTheme: getDarkTheme(),
//         home: Scaffold(
//           backgroundColor: Theme.of(context).colorScheme.background,
//           appBar: AppBar(
//             title: const Text("RoutePicker"),
//             elevation: 2,
//           ),
//           body: BlocConsumer<MapBloc, MapState>(
//             listener: (context, state) {
//               if (state is MapError) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text(state.message)),
//                 );
//               }
//             },
//             builder: (context, state) {
//               if (state is MapInitial || state is MapLoading) {
//                 return const Center(child: CircularProgressIndicator());
//               } else if (state is MapLoaded) {
//                 return Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: TextField(
//                         decoration: const InputDecoration(
//                           labelText: 'Enter distance in km',
//                           border: OutlineInputBorder(),
//                         ),
//                         keyboardType: TextInputType.number,
//                         onSubmitted: (value) {
//                           double distance = double.parse(value);
//                           context.read<MapBloc>().add(GenerateLoopRouteOptions(distance));
//                         },
//                       ),
//                     ),
//                     Expanded(
//                       child: MyMap(onAddressChanged: _updateAddress),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Column(
//                         children: [
//                           Text(_address),
//                           Text(_postalInfo),
//                         ],
//                       ),
//                     ),
//                     if (state.routeOptions.isNotEmpty)
//                       Column(
//                         children: [
//                           Container(
//                             height: 150,
//                             child: ListView.builder(
//                               itemCount: state.routeOptions.length,
//                               itemBuilder: (context, index) {
//                                 return ListTile(
//                                   title: Text("Route ${index + 1}"),
//                                   trailing: ElevatedButton(
//                                     onPressed: () {
//                                       // Navigate to RouteDetailScreen with the selected route
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (context) => RouteDetailScreen(
//                                             route: state.routeOptions[index],
//                                           ),
//                                         ),
//                                       );
//                                     },
//                                     child: Text('View'),
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),
//                           const SizedBox(height: 10),
//                           Text("Selected Route Distance: ${state.selectedRouteDistance.toStringAsFixed(2)} km"),
//                         ],
//                       ),
//                   ],
//                 );
//               } else {
//                 return Center(child: Text("Error. state: ${state}"));
//               }
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
