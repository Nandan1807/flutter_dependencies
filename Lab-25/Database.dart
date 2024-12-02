import 'dart:convert';
import 'package:http/http.dart' as http;
class MyDatabase{
String baseUrl = 'https://yourapi.com'; // Replace with your API URL

// Fetch items
Future<List<Map<String, dynamic>>> fetchItems() async {
  final response = await http.get(Uri.parse('$baseUrl/items'));
  if (response.statusCode == 200) {
    return List<Map<String, dynamic>>.from(json.decode(response.body));
  } else {
    throw Exception('Failed to load items');
  }
}

// Add item
Future<void> addItem(String title, String description) async {
  final response = await http.post(
    Uri.parse('$baseUrl/items'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({'title': title, 'description': description}),
  );
  if (response.statusCode != 201) {
    throw Exception('Failed to add item');
  }
}

// Update item
Future<void> updateItem(int id, String title, String description) async {
  final response = await http.put(
    Uri.parse('$baseUrl/items/$id'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({'title': title, 'description': description}),
  );
  if (response.statusCode != 200) {
    throw Exception('Failed to update item');
  }
}

// Delete item
Future<void> deleteItem(int id) async {
  final response = await http.delete(Uri.parse('$baseUrl/items/$id'));
  if (response.statusCode != 200) {
    throw Exception('Failed to delete item');
  }
}

}