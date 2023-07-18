import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:myapp/helpscreen.dart';

class HomepageScreen extends StatefulWidget {
  @override
  _HomepageScreenState createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {
  final TextEditingController _locationController = TextEditingController();
  String _locationName = '';
  String _temperatureCelsius = '';
  String _temperatureText = '';
  String _temperatureIconUrl = '';
  double _latitude = 0.0;
  double _longitude = 0.0;
  bool showElement = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HelpScreen()),
                );
              }),
          // Navigate back to the main page

          centerTitle: true,
          title: Text('Homepage'),
          backgroundColor: Colors.pinkAccent,
         
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'Location Name',
                  prefixIcon: Icon(
                    Icons.location_on,
                    size: 24.0, // Adjust the size of the icon as desired
                    color: Colors.pinkAccent, // Customize the color of the icon
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.pinkAccent),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _locationName = value;
                  });
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _fetchWeatherData();
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.pinkAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        10.0), // Customize the button shape
                  ), // Set the background color here
                ),
                child: Text(_locationName.isEmpty ? 'Save' : 'Update'),
              ),
              SizedBox(height: 16),
              if (_temperatureCelsius.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Temperature: $_temperatureCelsius°C',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text('Condition: $_temperatureText'),
                    Image.network(_temperatureIconUrl),
                  ],
                ),
              SizedBox(
                height: 20,
              ),
              if (_latitude != 0.0 && _longitude != 0.0)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Latitude: $_latitude, Longitude: $_longitude',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              SizedBox(height: 16),
            ],
          ),
        ));
  }

  Future<void> _fetchWeatherData() async {
    final apiKey = '1bc0383d81444b58b1432929200711';

    String url;
    if (_locationName.isEmpty) {
      final currentLocation = await _getCurrentLocation();
      if (currentLocation != null) {
        double latitude = currentLocation.latitude;
        double longitude = currentLocation.longitude;
        final apiKey = '1bc0383d81444b58b1432929200711';

        // Use the latitude and longitude values as needed
        url =
            'http:/1bc0383d81444b58b1432929200711/a/v1/current.json?key=$apiKey&q=$latitude,$longitude';
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Failed to get fetch weather'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            );
          },
        );
        return;
      }
    } else {
      url =
          'http://api.weatherapi.com/v1/current.json?key=$apiKey&q=$_locationName';
    }

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _temperatureCelsius = data['current']['temp_c'].toString();
        _temperatureText = data['current']['condition']['text'];
        _temperatureIconUrl = 'http:' + data['current']['condition']['icon'];
      });
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to fetch weather data.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        },
      );
    }
  }

  Future<Position?> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Location services are disabled.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        },
      );
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Location permissions are denied.'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            );
          },
        );
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(
                'Location permissions are permanently denied. Please enable location services from device settings.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        },
      );
      return null;
    }

    try {
      Position? currentPosition = await Geolocator.getCurrentPosition();
      if (currentPosition != null) {
        setState(() {
          _latitude = currentPosition.latitude;
          _longitude = currentPosition.longitude;
        });
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to get current location.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        },
      );

      return null;
    }
  }
}
