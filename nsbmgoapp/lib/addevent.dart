import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventForm extends StatefulWidget {
  final Map<String, dynamic> organizerData;

  const EventForm({Key? key, required this.organizerData}) : super(key: key);

  @override
  _EventFormState createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _dateTimeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;

  Future<void> _selectDateTime(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime != null) {
        setState(() {
          String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
          String formattedTime = pickedTime.format(context);
          _dateTimeController.text = "$formattedDate $formattedTime";
        });
      }
    }
  }

  Future<void> _createEvent() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await FirebaseFirestore.instance.collection('events').add({
        'eventName': _eventNameController.text,
        'dateTime': _dateTimeController.text,
        'location': _locationController.text,
        'imageUrl': _imageUrlController.text,
        'description': _descriptionController.text,
        'organizerId': widget.organizerData['email'],
        'organizerName': widget.organizerData['name'],
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Event created successfully!')),
      );

      _formKey.currentState!.reset();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating event: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Create New Event",
            style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.network(
                    "https://via.placeholder.com/120x50",
                    height: 50,
                  ),
                ),
                SizedBox(height: 10),
                Text("Please enter the details of the event below.",
                    style: TextStyle(fontSize: 14)),
                SizedBox(height: 20),
                _buildLabel("Event Name"),
                _buildTextField(
                  _eventNameController,
                  hintText: "Enter event name",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter event name';
                    }
                    return null;
                  },
                ),
                _buildLabel("Date & Time"),
                _buildDateTimeField(context),
                _buildLabel("Location"),
                _buildTextField(
                  _locationController,
                  hintText: "Enter event location",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter location';
                    }
                    return null;
                  },
                ),
                _buildLabel("Image URL"),
                _buildTextField(
                  _imageUrlController,
                  hintText: "Enter image URL (optional)",
                ),
                _buildLabel("Description"),
                _buildTextField(
                  _descriptionController,
                  hintText: "Enter event description",
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter description';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _createEvent,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[300],
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    child: _isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text("Create Event",
                        style: TextStyle(color: Colors.black, fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 5),
      child: Text(text,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, {
        int maxLines = 1,
        String? hintText,
        String? Function(String?)? validator,
      }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.green[200],
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildDateTimeField(BuildContext context) {
    return TextFormField(
      controller: _dateTimeController,
      readOnly: true,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.green[200],
        hintText: "Select date and time",
        suffixIcon: IconButton(
          icon: Icon(Icons.calendar_today),
          onPressed: () => _selectDateTime(context),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select date and time';
        }
        return null;
      },
    );
  }
}