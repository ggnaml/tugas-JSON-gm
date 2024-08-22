import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Setingan TabMenu
class TabScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text('SMK Negeri 4 - Mobile Apps'),
          backgroundColor: Colors.teal,
        ),
        body: TabBarView(
          children: [
            BerandaTab(),
            UsersTab(),
            ProfilTab(),
          ],
        ),
        bottomNavigationBar: TabBar(
          tabs: [
            Tab(icon: Icon(Icons.home), text: 'Beranda'),
            Tab(icon: Icon(Icons.people), text: 'Siswa'),
            Tab(icon: Icon(Icons.person), text: 'Profil'),
          ],
          labelColor: Colors.teal,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.teal,
        ),
      ),
    );
  }
}

// Layout untuk Tab Beranda
class BerandaTab extends StatelessWidget {
  final List<Map<String, dynamic>> menuItems = [
    {'icon': Icons.school, 'label': 'Informasi Akademik'},
    {'icon': Icons.book, 'label': 'Materi Pelajaran'},
    {'icon': Icons.event, 'label': 'Jadwal Kegiatan'},
    {'icon': Icons.notifications, 'label': 'Pengumuman'},
    {'icon': Icons.assignment, 'label': 'Tugas'},
    {'icon': Icons.chat, 'label': 'Forum Diskusi'},
    {'icon': Icons.calendar_today, 'label': 'Agenda'},
    {'icon': Icons.map, 'label': 'Peta Kampus'},
    {'icon': Icons.help, 'label': 'Bantuan'},
    {'icon': Icons.contact_support, 'label': 'Kontak Dukungan'},
    {'icon': Icons.info, 'label': 'Informasi Sekolah'},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Number of items per row
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
        ),
        itemCount: menuItems.length,
        itemBuilder: (context, index) {
          final item = menuItems[index];
          return GestureDetector(
            onTap: () {
              // Handle tap on the menu icon
              print('${item['label']} tapped');
            },
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(item['icon'], size: 50.0, color: Colors.teal),
                  SizedBox(height: 8.0),
                  Text(
                    item['label'],
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14.0, color: Colors.teal),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Layout untuk Tab User
class UsersTab extends StatelessWidget {
  Future<List<User>> fetchUsers() async {
    final response =
        await http.get(Uri.parse('https://reqres.in/api/users?page=2'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((user) => User.fromJson(user)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Siswa'),
        backgroundColor: Colors.teal,
      ),
      body: FutureBuilder<List<User>>(
        future: fetchUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final users = snapshot.data!;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    leading: CircleAvatar(
                      backgroundColor: Colors.teal,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    title: Text(user.firstName, style: TextStyle(fontSize: 16)),
                    subtitle: Text(user.email, style: TextStyle(fontSize: 14)),
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}

// Layout untuk Tab Profil
class ProfilTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/profile_picture.jpg'), // Ganti dengan path gambar profil
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: Text(
              'Salma Aziqhah Ramadhan',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
          ),
          SizedBox(height: 10),
          Center(
            child: Text(
              'Email: salmaaziqhahramadhan@gmail.com',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
          ),
          SizedBox(height: 30),
          Text(
            'Biodata',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Divider(),
          Card(
            margin: EdgeInsets.symmetric(vertical: 8),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: Icon(Icons.person, color: Colors.teal),
              title: Text('Nama Lengkap'),
              subtitle: Text('Salma Aziqhah Ramadhan'),
            ),
          ),
          Card(
            margin: EdgeInsets.symmetric(vertical: 8),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: Icon(Icons.cake, color: Colors.teal),
              title: Text('Tanggal Lahir'),
              subtitle: Text('27 September 2006'),
            ),
          ),
          Card(
            margin: EdgeInsets.symmetric(vertical: 8),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: Icon(Icons.school, color: Colors.teal),
              title: Text('Kelas'),
              subtitle: Text('XII IPA 1'),
            ),
          ),
        ],
      ),
    );
  }
}

// Model untuk User
class User {
  final String firstName;
  final String email;
  User({required this.firstName, required this.email});
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      firstName: json['first_name'],
      email: json['email'],
    );
  }
}