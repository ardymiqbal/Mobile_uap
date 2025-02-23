import 'package:flutter/material.dart';

class MyListPage extends StatelessWidget {
  final List<String> myList = [
    'Movie 1', 'TV Show 1', 'Anime 1', // Tambahkan item favorit Anda di sini
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My List")),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Menampilkan 3 item per baris
          crossAxisSpacing: 10, // Jarak antar item secara horizontal
          mainAxisSpacing: 10, // Jarak antar item secara vertikal
        ),
        itemCount: myList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // Implementasikan navigasi ke halaman detail item
            },
            child: Card(
              elevation: 4.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 150, // Tinggi gambar item
                    color: Colors.grey[300], // Ganti dengan gambar nyata
                    child: Center(
                      child: Icon(Icons.movie,
                          size: 50), // Ganti dengan gambar nyata
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      myList[index],
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis, // Membatasi panjang teks
                    ),
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
