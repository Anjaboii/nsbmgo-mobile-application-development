import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NSBM Events',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const NSBMHomePage(),
    );
  }
}

class NSBMHomePage extends StatelessWidget {
  const NSBMHomePage({super.key});

  final List<Map<String, String>> events = const [
    {'title': 'SPORTS FIESTA', 'image': 'assets/SF.jpg'},
    {'title': 'SIYAPATHSIYA UDANAYA', 'image': 'assets/SP.jpg'},
    {'title': 'NSBM PIRITH CHANTING', 'image': 'assets/PC.png'},
    {'title': 'GREEN FIESTA', 'image': 'assets/NF.jpg'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Image.asset('assets/nsbmlogo.png', height: 30),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'NSBM Event',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Top Row (2 Events)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                EventCard(title: events[0]['title']!, image: events[0]['image']!),
                EventCard(title: events[1]['title']!, image: events[1]['image']!),
              ],
            ),

            const SizedBox(height: 10),

            // Centered NSBM COLOURS
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/CL.png', // Centered event
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'NSBM COLOURS',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 10),

            // Bottom Row (2 Events)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                EventCard(title: events[2]['title']!, image: events[2]['image']!),
                EventCard(title: events[3]['title']!, image: events[3]['image']!),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset("assets/events_icon.png", height: 24),
            label: "Events",
          ),
          BottomNavigationBarItem(
            icon: Image.asset("assets/clubs_icon.png", height: 24),
            label: "Clubs",
          ),
          BottomNavigationBarItem(
            icon: Image.asset("assets/home_icon.png", height: 24),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Image.asset("assets/faculties_icon.png", height: 24),
            label: "Faculties",
          ),
          BottomNavigationBarItem(
            icon: Image.asset("assets/profile_icon.png", height: 24),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final String title;
  final String image;

  const EventCard({super.key, required this.title, required this.image});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            image,
            height: 100,
            width: 140,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
