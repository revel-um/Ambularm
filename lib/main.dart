import 'package:ambularm/constants/app_constants.dart';
import 'package:ambularm/utils/location.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<void> main() async {
  await dotenv.load(fileName: "assets/environments/.env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.edgeToEdge); // Enable Edge-to-Edge on Android 10+

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor:
            Colors.transparent, // Setting a transparent navigation bar color
        systemNavigationBarContrastEnforced: true, // Default
        systemNavigationBarIconBrightness:
            Brightness.light, // This defines the color of the scrim
        statusBarColor: Colors.transparent,
        systemStatusBarContrastEnforced: true,
        statusBarIconBrightness: Brightness.light));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppConstants.appName,
      theme:
          ThemeData(useMaterial3: true, colorScheme: const ColorScheme.light()),
      home: const MyHomePage(title: AppConstants.appName),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  LatLng currentLocation = const LatLng(28.7041, 77.1025);

  @override
  Widget build(BuildContext context) {
    print('build');
    return Scaffold(
      body: GoogleMap(
        onMapCreated: _onMapCreation,
        initialCameraPosition: CameraPosition(
          target: currentLocation,
          zoom: AppConstants.mapZoom,
        ),
        markers: {
          Marker(
            markerId: const MarkerId("marker1"),
            position: currentLocation,
          ),
        },
        minMaxZoomPreference: const MinMaxZoomPreference(11, 19),
        myLocationButtonEnabled: true,
        zoomControlsEnabled: false,
      ),
    );
  }

  Future<void> _onMapCreation(controller) async {
    try {
      final location = await determinePosition();
      currentLocation = LatLng(location.latitude, location.longitude);
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: currentLocation,
            zoom: AppConstants.mapZoom,
          ),
        ),
      );
      setState(() {

      });
      print(location);
    } catch (error) {
      print('error in location determination: $error');
      //Location determination failed
    }
  }
}
