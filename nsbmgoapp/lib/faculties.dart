import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FacultyScreen(),
    );
  }
}

class FacultyScreen extends StatefulWidget {
  @override
  _FacultyScreenState createState() => _FacultyScreenState();
}

class _FacultyScreenState extends State<FacultyScreen> {
  final List<Map<String, String>> faculties = [
    {
      "name": "Faculty Of Computing",
      "image": "assets/FOC.jpg",
    },
    {
      "name": "Faculty Of Business",
      "image": "assets/FOB.jpeg",
    },
    {
      "name": "Faculty Of Science",
      "image": "assets/FOS.jpg",
    },
    {
      "name": "Faculty Of Engineering",
      "image": "assets/FOE.png",
    },
  ];

  int _selectedIndex = 3;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset('assets/nsbmlogo.png', height: 40),
                  SizedBox(height: 16),
                  Text("Faculties", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: faculties.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: FacultyCard(
                      name: faculties[index]['name']!,
                      image: faculties[index]['image']!,
                      isSelected: index == 0,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(icon: Image.asset("assets/events_icon.png", height: 24), label: "Events"),
          BottomNavigationBarItem(icon: Image.asset("assets/clubs_icon.png", height: 24), label: "Clubs"),
          BottomNavigationBarItem(icon: Image.asset("assets/home_icon.png", height: 24), label: "Home"),
          BottomNavigationBarItem(icon: Image.asset("assets/faculties_icon.png", height: 24), label: "Faculties"),
          BottomNavigationBarItem(icon: Image.asset("assets/profile_icon.png", height: 24), label: "Profile"),
        ],
      ),
    );
  }
}

class FacultyCard extends StatelessWidget {
  final String name;
  final String image;
  final bool isSelected;

  FacultyCard({required this.name, required this.image, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: isSelected ? Border.all(color: Colors.blue, width: 2) : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 3),
              )
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(image, fit: BoxFit.cover, width: double.infinity, height: 150),
          ),
        ),
        SizedBox(height: 8),
        Text(
          name,
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}