import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Map<String, dynamic>? _studentData;
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchStudentData();
  }

  Future<void> _fetchStudentData() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        setState(() {
          _errorMessage = 'No user logged in';
          _isLoading = false;
        });
        return;
      }

      final doc = await _firestore.collection('student').doc(user.uid).get();

      if (!doc.exists) {
        setState(() {
          _errorMessage = 'Student data not found';
          _isLoading = false;
        });
        return;
      }

      setState(() {
        _studentData = doc.data();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error fetching data: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.green,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
          ? Center(child: Text(_errorMessage))
          : _buildProfileContent(),
    );
  }

  Widget _buildProfileContent() {
    final dateOfBirth = (_studentData!['dateofbirth'] as Timestamp).toDate();
    final formattedDate = '${dateOfBirth.day} ${_getMonthName(dateOfBirth.month)} ${dateOfBirth.year}';

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey.shade200,
            child: _studentData!['image'] != null && _studentData!['image'].isNotEmpty
                ? ClipOval(
              child: Image.network(
                _studentData!['image'],
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            )
                : Icon(
              Icons.person,
              size: 50,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 20),
          Text(
            _studentData!['name'] ?? 'No Name',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Text(
            _studentData!['studentid'] ?? 'No ID',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          SizedBox(height: 30),
          _buildInfoCard(
            icon: Icons.email,
            title: 'Email',
            value: _studentData!['email'] ?? 'No Email',
          ),
          _buildInfoCard(
            icon: Icons.cake,
            title: 'Date of Birth',
            value: formattedDate,
          ),
          _buildInfoCard(
            icon: Icons.school,
            title: 'Intake',
            value: _studentData!['intake'] ?? 'No Intake',
          ),
          _buildInfoCard(
            icon: Icons.account_balance,
            title: 'Faculty',
            value: 'Faculty of Computing',
          ),
          _buildInfoCard(
            icon: Icons.assignment,
            title: 'Degree',
            value: _studentData!['degree'] ?? 'No Degree',
          ),
          _buildInfoCard(
            icon: Icons.phone,
            title: 'Phone',
            value: _studentData!['phoneno'] ?? 'No Phone',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({required IconData icon, required String title, required String value}) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.green),
        title: Text(title, style: TextStyle(color: Colors.grey)),
        subtitle: Text(value, style: TextStyle(fontSize: 16)),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      "January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December"
    ];
    return months[month - 1];
  }
}