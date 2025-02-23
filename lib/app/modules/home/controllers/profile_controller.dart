import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_storage/get_storage.dart';

class ProfileController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Connectivity _connectivity = Connectivity();
  final GetStorage _storage = GetStorage();

  var username = ''.obs;
  var name = ''.obs;
  var age = ''.obs;
  var phoneNumber = ''.obs;

  final List<RxMap<String, dynamic>> profiles = <RxMap<String, dynamic>>[
    <String, dynamic>{'profileImage': null}.obs
  ];

  var activeProfileIndex = 0.obs;
  final String _localDataKey = 'pendingUserData';

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
    _checkAndUploadPendingData();
  }

  void fetchUserProfile() async {
    final user = _auth.currentUser;
    if (user != null) {
      username.value = user.email ?? '';
      await fetchUserDetails(user.uid);
    }
  }

  Future<void> fetchUserDetails(String uid) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        name.value = doc['name'] ?? '';
        age.value = doc['age'] ?? '';
        phoneNumber.value = doc['phoneNumber'] ?? '';
      }
    } catch (e) {
      print("Error fetching user details: $e");
    }
  }

  Future<void> editUser(String name, String age, String phoneNumber) async {
    final user = _auth.currentUser;
    if (user != null) {
      final data = {'name': name, 'age': age, 'phoneNumber': phoneNumber};

      this.name.value = name;
      this.age.value = age;
      this.phoneNumber.value = phoneNumber;

      _storage.write(_localDataKey, data);

      Future(() async {
        try {
          final connectivityResult = await _connectivity.checkConnectivity();
          if (connectivityResult != ConnectivityResult.none) {
            await _firestore.collection('users').doc(user.uid).set(data, SetOptions(merge: true));
            await _storage.remove(_localDataKey);
            Get.snackbar('Success', 'Data updated successfully!');
          } else {
            Get.snackbar('Offline', 'Data saved locally. Will upload when online.');
          }
        } catch (e) {
          print("Error updating user data: $e");
          Get.snackbar('Error', 'Failed to update data. Saved locally.');
        }
      });
    }
  }

  Future<void> _checkAndUploadPendingData() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      await _retryUpload();
    }
    _connectivity.onConnectivityChanged.listen((result) async {
      if (result != ConnectivityResult.none) {
        await _retryUpload();
      }
    });
  }

  Future<void> _retryUpload() async {
    final pendingData = _storage.read(_localDataKey);
    if (pendingData != null) {
      try {
        final user = _auth.currentUser;
        if (user != null) {
          await _firestore.collection('users').doc(user.uid).set(pendingData, SetOptions(merge: true));
          _storage.remove(_localDataKey);
          Get.snackbar('Success', 'Pending data uploaded successfully!');
        }
      } catch (e) {
        print("Error uploading pending data: $e");
      }
    }
  }

  void setActiveProfile(int index) {
    if (index >= 0 && index < profiles.length) {
      activeProfileIndex.value = index;
    }
  }

  void addProfile() {
    if (profiles.length < 3) {
      profiles.add(<String, dynamic>{'profileImage': null}.obs);
      setActiveProfile(profiles.length - 1);
    }
  }

  void logout() async {
    await _auth.signOut();
    username.value = '';
    name.value = '';
    age.value = '';
    phoneNumber.value = '';
    profiles.clear();
    profiles.add(<String, dynamic>{'profileImage': null}.obs);
    activeProfileIndex.value = 0;
    Get.offAllNamed('/login');
  }

  Future<void> deleteUser() async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        await _firestore.collection('users').doc(user.uid).delete();
        await user.delete();
        logout();
      } catch (e) {
        print("Error deleting user: $e");
      }
    }
  }

  Future<void> registerUser(String name, String age, String phoneNumber, String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      await _firestore.collection('users').doc(userCredential.user?.uid).set({'name': name, 'age': age, 'phoneNumber': phoneNumber});
      Get.snackbar('Success', 'Registration successful!');
    } catch (e) {
      print('Error during registration: $e');
      Get.snackbar('Error', 'Registration failed: $e');
    }
  }
  // Pilih gambar dari galeri
  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final bytes = await image.readAsBytes();
        profiles[activeProfileIndex.value]['profileImage'] = bytes;
        Get.snackbar('Success', 'Image selected successfully!');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image: $e');
    }
  }

  // Ambil gambar dari kamera
  Future<void> captureImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        final bytes = await image.readAsBytes();
        profiles[activeProfileIndex.value]['profileImage'] = bytes;
        Get.snackbar('Success', 'Image captured successfully!');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to capture image: $e');
    }
  }

}
