import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationDropdowns extends StatefulWidget {
  @override
  _LocationDropdownsState createState() => _LocationDropdownsState();
}

class _LocationDropdownsState extends State<LocationDropdowns> {
  // Lists for dropdown data
  List<dynamic> countries = [];
  List<dynamic> states = [];
  List<dynamic> cities = [];

  // Selected values
  String? selectedCountry;
  String? selectedState;
  String? selectedCity;

  @override
  void initState() {
    super.initState();
    fetchCountries(); // Load country data on start
  }

  // Fetch country list
  Future<void> fetchCountries() async {
    final response = await http.get(Uri.parse('https://yourapi.com/countries'));
    if (response.statusCode == 200) {
      setState(() {
        countries = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load countries');
    }
  }

  // Fetch state list based on selected country
  Future<void> fetchStates(String countryId) async {
    final response = await http.get(Uri.parse('https://yourapi.com/states?country_id=$countryId'));
    if (response.statusCode == 200) {
      setState(() {
        states = json.decode(response.body);
        cities = []; // Reset cities
        selectedState = null;
        selectedCity = null;
      });
    } else {
      throw Exception('Failed to load states');
    }
  }

  // Fetch city list based on selected state
  Future<void> fetchCities(String stateId) async {
    final response = await http.get(Uri.parse('https://yourapi.com/cities?state_id=$stateId'));
    if (response.statusCode == 200) {
      setState(() {
        cities = json.decode(response.body);
        selectedCity = null; // Reset city selection
      });
    } else {
      throw Exception('Failed to load cities');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Location Dropdowns')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Country Dropdown
            DropdownButtonFormField<String>(
              value: selectedCountry,
              hint: Text('Select Country'),
              items: countries.map<DropdownMenuItem<String>>((country) {
                return DropdownMenuItem<String>(
                  value: country['id'].toString(),
                  child: Text(country['name']),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCountry = value;
                });
                if (value != null) fetchStates(value);
              },
              decoration: InputDecoration(border: OutlineInputBorder()),
            ),
            SizedBox(height: 20),

            // State Dropdown
            DropdownButtonFormField<String>(
              value: selectedState,
              hint: Text('Select State'),
              items: states.map<DropdownMenuItem<String>>((state) {
                return DropdownMenuItem<String>(
                  value: state['id'].toString(),
                  child: Text(state['name']),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedState = value;
                });
                if (value != null) fetchCities(value);
              },
              decoration: InputDecoration(border: OutlineInputBorder()),
            ),
            SizedBox(height: 20),

            // City Dropdown
            DropdownButtonFormField<String>(
              value: selectedCity,
              hint: Text('Select City'),
              items: cities.map<DropdownMenuItem<String>>((city) {
                return DropdownMenuItem<String>(
                  value: city['id'].toString(),
                  child: Text(city['name']),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCity = value;
                });
              },
              decoration: InputDecoration(border: OutlineInputBorder()),
            ),
          ],
        ),
      ),
    );
  }
}
