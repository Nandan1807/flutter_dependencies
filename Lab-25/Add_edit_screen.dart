import 'package:flutter/material.dart';

import 'Database.dart';

class AddEditScreen extends StatefulWidget {
  final Map<String, dynamic>? item;
  final VoidCallback onSaved;

  const AddEditScreen({this.item, required this.onSaved});

  @override
  _AddEditScreenState createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      titleController.text = widget.item!['title'];
      descriptionController.text = widget.item!['description'];
    }
  }

  Future<void> saveItem() async {
    setState(() {
      isLoading = true;
    });

    try {
      if (widget.item == null) {
        await MyDatabase().addItem(titleController.text.trim(), descriptionController.text.trim());
      } else {
        await MyDatabase().updateItem(
          widget.item!['id'],
          titleController.text.trim(),
          descriptionController.text.trim(),
        );
      }
      widget.onSaved();
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item == null ? 'Add Item' : 'Edit Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading ? null : saveItem,
              child: isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text(widget.item == null ? 'Add' : 'Update'),
            ),
          ],
        ),
      ),
    );
  }
}
