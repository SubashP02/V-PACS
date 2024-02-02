import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

class Map_Page extends StatefulWidget {
  final Function handleMapClick;
  final Function callback;
  const Map_Page(
      {Key? key, required this.handleMapClick, required this.callback})
      : super(key: key);

  @override
  State<Map_Page> createState() => _MapPageState();
}

class _MapPageState extends State<Map_Page> {
  Location _locationController = Location();
  List<LatLng> _locations = [];
  BitmapDescriptor? markerIcon;
  late String apiUrl;
  late StreamSubscription<LocationData> _locationSubscription;
  bool isFullScreen = false;

  @override
  void initState() {
    super.initState();
    apiUrl =
        'http://13.127.214.1:3000/api/v1/VID_12348/vehicledata/2024-01-31/2024-01-31';
    fetchData(apiUrl); // Fetch initial data
    getLocationUpdates();
    addCustomIcon();
  }

  @override
  void dispose() {
    _locationSubscription.cancel(); // Stop listening for location updates
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        widget.handleMapClick();
      },
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(25.0),
            child: Container(
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target:
                      _locations.isNotEmpty ? _locations.first : LatLng(0, 0),
                  zoom: 15,
                ),
                myLocationEnabled: true,
                zoomControlsEnabled: false,
                markers: _locations
                    .map(
                      (location) => Marker(
                        markerId: MarkerId(location.toString()),
                        icon: BitmapDescriptor.defaultMarker,
                        position: location,
                      ),
                    )
                    .toSet(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getLocationUpdates() async {
    _locationSubscription = _locationController.onLocationChanged.listen(
      (LocationData location) {
        if (location.latitude != null && location.longitude != null) {
          setState(() {
            _locations.add(LatLng(location.latitude!, location.longitude!));
          });
        }
      },
    );
  }

  Future<void> addCustomIcon() async {
    BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(48, 48)),
      'images/stacker2.png',
    ).then((icon) {
      setState(() {
        markerIcon = icon;
      });
    });
  }

  Future<void> fetchData(String url) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final user = json.decode(response.body);

        if (user.containsKey('latitude') && user.containsKey('longitude')) {
          final latitude = user['latitude'];
          final longitude = user['longitude'];

          setState(() {
            _locations.add(LatLng(latitude, longitude));
          });
        } else {
          print(
              'Failed to fetch data. Latitude or Longitude not present in response.');
        }
      } else {
        print('Failed to fetch data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }
}
