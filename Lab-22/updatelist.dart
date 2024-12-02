import 'package:flutter/material.dart';

class RefreshListScreen extends StatefulWidget {
  @override
  _RefreshListScreenState createState() => _RefreshListScreenState();
}

class _RefreshListScreenState extends State<RefreshListScreen> {
  // List of items (example data)
  List<String> items = ['Item 1', 'Item 2', 'Item 3', 'Item 4'];

  // Function to simulate data update
  void updateData() {
    setState(() {
      // Update the list with new data (simulated)
      items.add('Item ${items.length + 1}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Refresh List Example'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: updateData,  // Call updateData when refresh button is pressed
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(items[index]),  // Display updated list item
            );
          },
        ),
      ),
    );
  }
}
