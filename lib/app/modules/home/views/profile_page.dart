import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tes1/app/modules/home/controllers/profile_controller.dart';
import 'package:tes1/app/modules/home/views/maps_page.dart';
import 'package:tes1/app/modules/home/views/music_view.dart';

class ProfilePage extends StatelessWidget {
  final ProfileController profileController = Get.put(ProfileController());

  ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 0, 0, 0), // Merah yang diminta
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'edit') {
                showEditDialog(context);
              } else if (value == 'delete') {
                profileController.deleteUser();
              } else if (value == 'logout') {
                profileController.logout();
              } else if (value == 'Backsound') {
                Get.to(() => MusicPlayerScreen());
              } else if (value == 'Maps') {
                Get.to(() => MapsPage());
              }
            },
            itemBuilder: (BuildContext context) {
              return {'edit', 'delete', 'logout', 'Backsound', 'Maps'}
                  .map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice.capitalizeFirst!),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black, // Warna hitam dominan
              const Color.fromARGB(255, 48, 2,
                  2), // Tambahkan hitam lagi untuk dominasi yang lebih kuat
              Color.fromARGB(255, 236, 22, 18), // Merah sedikit di bagian bawah
            ],
            stops: [0.1, 0.5, 10.0], // Menentukan tempat peralihan gradien
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Display user email
              Obx(() {
                return Text(
                  'Logged in as: ${profileController.username}',
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                );
              }),
              const SizedBox(height: 20),
              // Frame for Image/Video
              Obx(() {
                var activeProfile = profileController
                    .profiles[profileController.activeProfileIndex.value];
                var profileImage = activeProfile['profileImage'];

                return Center(
                  child: Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey),
                    ),
                    child: profileImage != null
                        ? ClipOval(
                            child: Image.memory(
                              profileImage,
                              fit: BoxFit.cover,
                              width: 160,
                              height: 160,
                            ),
                          )
                        : const Center(
                            child: Icon(Icons.person,
                                size: 80, color: Colors.grey),
                          ),
                  ),
                );
              }),
              const SizedBox(height: 20),
              // Buttons for media actions
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: profileController.pickImage,
                    icon: const Icon(Icons.image, color: Colors.white),
                    label: const Text('Pick Image',
                        style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(
                          255, 236, 22, 18), // Merah yang diminta
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      textStyle:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 15),
                  ElevatedButton.icon(
                    onPressed: profileController.captureImage,
                    icon: const Icon(Icons.camera, color: Colors.white),
                    label: const Text('Capture Image',
                        style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(
                          255, 236, 22, 18), // Merah yang diminta
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      textStyle:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Profile details
              Obx(() {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Name: ${profileController.name.value}',
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white)),
                    Text('Age: ${profileController.age.value}',
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white)),
                    Text('Phone: ${profileController.phoneNumber.value}',
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white)),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  // Dialog to edit profile details
  void showEditDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController ageController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();

    var activeProfile =
        profileController.profiles[profileController.activeProfileIndex.value];
    nameController.text = profileController.name.value;
    ageController.text = profileController.age.value;
    phoneController.text = profileController.phoneNumber.value;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color.fromARGB(255, 0, 0, 0), // Merah yang diminta
          title: const Text(
            'Edit Profile',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              TextField(
                controller: ageController,
                decoration: const InputDecoration(
                  labelText: 'Age',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                profileController
                    .editUser(
                  nameController.text,
                  ageController.text,
                  phoneController.text,
                )
                    .then((_) {
                  Navigator.of(context).pop();
                }).catchError((error) {
                  Get.snackbar('Error', 'Could not update profile: $error');
                });
              },
              child: const Text('Save', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
