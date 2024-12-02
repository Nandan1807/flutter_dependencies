import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EntryScreen extends StatefulWidget {
  @override
  _EntryScreenState createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Text controllers for form fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  // Submit data to webserver
  Future<void> submitData() async {
    if (!_formKey.currentState!.validate()) return;

    // Data to send in POST request
    final Map<String, String> data = {
      'name': nameController.text,
      'dob': dobController.text,
      'city': cityController.text,
      'address': addressController.text,
    };

    try {
      final response = await http.post(
        Uri.parse('https://yourapi.com/submit'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: data,
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Success'),
            content: Text(responseData['message']),
          ),
        );
      } else {
        throw Exception('Failed to submit data');
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Error'),
          content: Text(e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Entry Form')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name Field
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name', border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Name is required';
                  return null;
                },
              ),
              SizedBox(height: 16),

              // DOB Field
              TextFormField(
                controller: dobController,
                decoration: InputDecoration(
                  labelText: 'Date of Birth (DD/MM/YYYY)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'DOB is required';
                  final dobRegex = RegExp(r'^\d{2}/\d{2}/\d{4}$');
                  if (!dobRegex.hasMatch(value)) return 'Invalid DOB format';
                  return null;
                },
              ),
              SizedBox(height: 16),

              // City Field
              TextFormField(
                controller: cityController,
                decoration: InputDecoration(labelText: 'City', border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'City is required';
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Address Field
              TextFormField(
                controller: addressController,
                decoration: InputDecoration(labelText: 'Address', border: OutlineInputBorder()),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Address is required';
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Submit Button
              Center(
                child: ElevatedButton(
                  onPressed: submitData,
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
