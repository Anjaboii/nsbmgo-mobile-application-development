import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProfilePage(),
    );
  }
}

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 4; // Profile tab selected by default

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Full white background
      body: Column(
        children: [
          SizedBox(height: 60), // Increased space for layout adjustment

          // Profile Image
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey[300],
            child: Icon(Icons.person, size: 50, color: Colors.black54),
          ),

          SizedBox(height: 20),

          // Name and ID
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.green[200],
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(2, 2)),
              ],
            ),
            child: Column(
              children: [
                Text("Kavindu Heshan", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text("29812", style: TextStyle(fontSize: 14, color: Colors.black87)),
              ],
            ),
          ),

          SizedBox(height: 30),

          // Profile Details
          profileInfoCard("Email", "kdesilva728@gmail.com"),
          profileInfoCard("Intake", "23.1"),
          profileInfoCard("Faculty", "Faculty of Computing"),
          profileInfoCard("Degree", "BSc(Hons) Software Engineering"),

          Spacer(),

          // Bottom Navigation Bar
          BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.black54,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            items: [
              BottomNavigationBarItem(icon: Image.asset("assets/events_icon.png", height: 24), label: "Events"),
              BottomNavigationBarItem(icon: Image.asset("assets/clubs_icon.png", height: 24), label: "Clubs"),
              BottomNavigationBarItem(icon: Image.asset("assets/home_icon.png", height: 24), label: "Home"),
              BottomNavigationBarItem(icon: Image.asset("assets/faculties_icon.png", height: 24), label: "Faculties"),
              BottomNavigationBarItem(icon: Image.asset("assets/profile_icon.png", height: 24), label: "Profile"),
            ],
          ),
        ],
      ),
    );
  }

  // Profile Info Card
  Widget profileInfoCard(String title, String value) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20), // Increased vertical margin
      padding: EdgeInsets.all(12),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.green[200], // Greenish background
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(2, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title :",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}