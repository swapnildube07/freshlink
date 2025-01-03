import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:freshlink/views/screens/Cart_Screen.dart';
import 'package:freshlink/views/screens/inner_screen/customerorder_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:freshlink/views/screens/auth/login_screen.dart';

class AccountScreen extends StatefulWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String? mobileNumber;
  String? fullName;
  String? email;
  String? profileImageUrl;
  File? _selectedImage; // To hold the selected image file
  bool _isLoading = false; // To manage loading state

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    CollectionReference buyers = FirebaseFirestore.instance.collection('buyers');
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.green.shade600,
        title: Text(
          'Profile',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.sunny_snowing,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: buyers.doc(widget._auth.currentUser!.uid).get(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) return Center(child: Text("Something went wrong"));
          if (snapshot.hasData && !snapshot.data!.exists) {
            return Center(child: Text("Document does not exist"));
          }
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
            mobileNumber = data['MobileNumber'];
            fullName = data['FullName'];
            email = data['email'];
            profileImageUrl = data['profileImage'];

            _nameController.text = fullName ?? '';
            _emailController.text = email ?? '';

            return SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: _showProfileImageOptions,
                        child: CircleAvatar(
                          radius: 65,
                          backgroundImage: _selectedImage != null
                              ? FileImage(_selectedImage!) // Show selected image
                              : NetworkImage(profileImageUrl ?? ''), // Show current image
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        fullName ?? '',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        email ?? '',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 20),
                      if (_selectedImage != null) // Show Save button if an image is selected
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade700,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: () {
                            if (_selectedImage != null) {
                              _uploadProfileImage(_selectedImage!);
                            }
                          },
                          child: _isLoading
                              ? CircularProgressIndicator(color: Colors.white) // Show loading indicator
                              : Text('Save', style: TextStyle(fontSize: 16)),
                        ),
                      SizedBox(height: 20),
                      Container(
                        width: 200,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade700,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: _showEditProfileDialog,
                          child: Text(
                            'Edit',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Divider(thickness: 2, color: Colors.grey[300]),
                      SizedBox(height: 10),
                      _buildListTile(Icons.settings, "Settings", () {}),
                      _buildListTile(Icons.phone, "Phone", () {
                        _showEditPhoneDialog(mobileNumber ?? "");
                      }, subtitle: mobileNumber),
                      _buildListTile(Icons.shopping_cart, "Cart", () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => CartScreen()));
                      }),
                      _buildListTile(Icons.shopping_bag, "Order", () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => CustomerOrderScreen()));
                      }),
                      _buildListTile(Icons.logout, "Logout", () async {
                        _showLogoutConfirmationDialog(context);
                      }),
                    ],
                  ),
                ),
              ),
            );
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildListTile(IconData icon, String title, VoidCallback onTap, {String? subtitle}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey[300]!, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: ListTile(
          leading: Icon(icon, color: Colors.green.shade700),
          title: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green.shade700),
          ),
          subtitle: subtitle != null ? Text(subtitle) : null,
        ),
      ),
    );
  }

  void _showEditPhoneDialog(String currentPhoneNumber) {
    TextEditingController phoneController = TextEditingController(text: currentPhoneNumber);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Phone Number'),
          content: TextField(
            controller: phoneController,
            decoration: InputDecoration(labelText: 'Phone Number'),
            keyboardType: TextInputType.phone,
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () async {
                String newPhoneNumber = phoneController.text.trim();
                if (newPhoneNumber.isNotEmpty) {
                  await _updateField('MobileNumber', newPhoneNumber);
                  setState(() {
                    mobileNumber = newPhoneNumber;
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditProfileDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Profile'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Full Name'),
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () async {
                await _updateField('FullName', _nameController.text.trim());
                await _updateField('email', _emailController.text.trim());
                setState(() {
                  fullName = _nameController.text.trim();
                  email = _emailController.text.trim();
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showProfileImageOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Pick a New Image'),
              onTap: () {
                Navigator.pop(context); // Close the modal
                _pickImage();
              },
            ),
            ListTile(
              leading: Icon(Icons.visibility),
              title: Text('View Profile Image'),
              onTap: () {
                Navigator.pop(context);
                _showProfileImage();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  void _showProfileImage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Image.file(_selectedImage!),
        );
      },
    );
  }

  Future<void> _updateField(String field, String newValue) async {
    try {
      await FirebaseFirestore.instance.collection('buyers').doc(widget._auth.currentUser!.uid).update({field: newValue});
    } catch (e) {
      print("Error updating field: $e");
    }
  }

  Future<void> _uploadProfileImage(File image) async {
    try {
      setState(() {
        _isLoading = true;
      });

      String imageName = widget._auth.currentUser!.uid + '_profile_image';
      Reference storageRef = FirebaseStorage.instance.ref().child('profile_images').child(imageName);
      await storageRef.putFile(image);
      String imageUrl = await storageRef.getDownloadURL();

      // Update Firestore with the new profile image URL
      await FirebaseFirestore.instance.collection('buyers').doc(widget._auth.currentUser!.uid).update({'profileImage': imageUrl});

      setState(() {
        profileImageUrl = imageUrl;
        _isLoading = false;
      });
      print('Profile image updated successfully!');
    } catch (e) {
      print("Error uploading image: $e");
    }
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Logout'),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
