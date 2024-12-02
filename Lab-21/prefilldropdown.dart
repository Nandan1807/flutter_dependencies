import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NestedAPIDropdowns extends StatefulWidget {
  @override
  _NestedAPIDropdownsState createState() => _NestedAPIDropdownsState();
}

class _NestedAPIDropdownsState extends State<NestedAPIDropdowns> {
  // Lists to store dropdown data
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
    fetchPrefilledData(); // Fetch prefilled data for all dropdowns
  }

  // Fetch prefilled data for Country, State, and City
  Future<void> fetchPrefilledData() async {
    try {
      final countryResponse = await http.get(Uri.parse('https://yourapi.com/countries'));
      final stateResponse = await http.get(Uri.parse('https://yourapi.com/states?country_id=1'));
      final cityResponse = await http.get(Uri.parse('https://yourapi.com/cities?state_id=1'));

      if (countryResponse.statusCode == 200 &&
          stateResponse.statusCode == 200 &&
          cityResponse.statusCode == 200) {
        setState(() {
          countries = json.decode(countryResponse.body);
          states = json.decode(stateResponse.body);
          cities = json.decode(cityResponse.body);

          selectedCountry = countries.isNotEmpty ? countries[0]['id'].toString() : null;
          selectedState = states.isNotEmpty ? states[0]['id'].toString() : null;
          selectedCity = cities.isNotEmpty ? cities[0]['id'].toString() : null;
        });
      } else {
        throw Exception('Failed to load initial data');
      }
    } catch (e) {
      print(e);
    }
  }

  // Fetch states when a country is selected
  Future<void> fetchStates(String countryId) async {
    final response = await http.get(Uri.parse('https://yourapi.com/states?country_id=$countryId'));
    if (response.statusCode == 200) {
      setState(() {
        states = json.decode(response.body);
        cities = []; // Reset cities
        selectedState = states.isNotEmpty ? states[0]['id'].toString() : null;
        selectedCity = null;
      });
      if (selectedState != null) fetchCities(selectedState!);
    }
  }

  // Fetch cities when a state is selected
  Future<void> fetchCities(String stateId) async {
    final response = await http.get(Uri.parse('https://yourapi.com/cities?state_id=$stateId'));
    if (response.statusCode == 200) {
      setState(() {
        cities = json.decode(response.body);
        selectedCity = cities.isNotEmpty ? cities[0]['id'].toString() : null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nested API Dropdowns')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
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
