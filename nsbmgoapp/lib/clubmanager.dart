import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ClubManagerPage extends StatefulWidget {
  final Map<String, dynamic> managerData;

  const ClubManagerPage({Key? key, required this.managerData}) : super(key: key);

  @override
  _ClubManagerPageState createState() => _ClubManagerPageState();
}

class _ClubManagerPageState extends State<ClubManagerPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _mailController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _typeController.dispose();
    _contactController.dispose();
    _descriptionController.dispose();
    _imageController.dispose();
    _mailController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _addClub() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await FirebaseFirestore.instance.collection('clubs').add({
        'name': _nameController.text.trim(),
        'clubtype': _typeController.text.trim(),
        'contactnumber': _contactController.text.trim(),
        'description': _descriptionController.text.trim(),
        'image': _imageController.text.trim(),
        'mail': _mailController.text.trim(),
        'url': _urlController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
        'createdBy': widget.managerData['name'] ?? 'Unknown Manager',
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Club added successfully!')),
      );

      // Clear the form after successful submission
      _formKey.currentState!.reset();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding club: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Club'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'NSBM Club Details',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'Please enter the details of the club below.',
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 30),
              _buildTextField('Club Name', _nameController, isRequired: true),
              const SizedBox(height: 20),
              _buildTextField('Club Type', _typeController),
              const SizedBox(height: 20),
              _buildTextField('Contact Number', _contactController),
              const SizedBox(height: 20),
              _buildTextField('Image URL', _imageController),
              const SizedBox(height: 20),
              _buildTextField('Email', _mailController),
              const SizedBox(height: 20),
              _buildTextField('Website URL', _urlController),
              const SizedBox(height: 20),
              _buildDescriptionField(),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _addClub,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                    'Add Club',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool isRequired = false}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: isRequired
          ? (value) {
        if (value == null || value.isEmpty) {
          return 'This field is required';
        }
        return null;
      }
          : null,
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      maxLines: 4,
      decoration: const InputDecoration(
        labelText: 'Description',
        alignLabelWithHint: true,
        border: OutlineInputBorder(),
      ),
    );
  }
}