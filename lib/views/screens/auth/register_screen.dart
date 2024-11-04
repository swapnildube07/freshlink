import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:freshlink/controllers/auth_controller.dart';
import 'package:freshlink/views/screens/auth/login_screen.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthController _authController = AuthController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  bool _isLoading = false;
  late String email, FullName, Password, MobileNumber;
  Uint8List? _image;

  selectGalleryImage() async {
    Uint8List Im = await _authController.pickProfileImage(ImageSource.gallery);
    setState(() {
      _image = Im;
    });
  }

  registeruser() async {
    if (_image != null && _formkey.currentState!.validate()) {
      setState(() => _isLoading = true);
      String res = await _authController.createNewUser(
          email, FullName, Password, MobileNumber, _image);
      setState(() => _isLoading = false);

      if (res == 'Success') {
        Get.to(LoginScreen());
        Get.snackbar('Success', "Account has been created for you",
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar('Error', res.toString(),
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } else {
      Get.snackbar('Form', "Please complete all fields and upload an image");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formkey,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Register Account',
                  style: TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 4),
                ),
                SizedBox(height: 20),
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 80,
                      backgroundImage: _image != null
                          ? MemoryImage(_image!)
                          : AssetImage('assets/icons/farmer.png')
                      as ImageProvider,
                    ),
                    Positioned(
                      right: 0,
                      top: 15,
                      child: IconButton(
                        onPressed: selectGalleryImage,
                        icon: Icon(CupertinoIcons.photo),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                // Full Name Field
                buildRoundedTextField(
                    labelText: 'Full Name',
                    hintText: 'Enter Full Name',
                    icon: Icons.person,
                    onChanged: (value) => FullName = value,
                    validator: (value) => value!.isEmpty
                        ? "Please enter your full name"
                        : null),

                SizedBox(height: 20),

                // Email Field
                buildRoundedTextField(
                    labelText: 'Email Address',
                    hintText: 'Enter Mail Address',
                    icon: Icons.email,
                    onChanged: (value) => email = value,
                    validator: (value) =>
                    value!.isEmpty ? "Please enter your email" : null),

                SizedBox(height: 20),

                // Password Field
                buildRoundedTextField(
                    labelText: 'Password',
                    hintText: 'Set Password',
                    icon: Icons.lock,
                    obscureText: true,
                    onChanged: (value) => Password = value,
                    validator: (value) =>
                    value!.isEmpty ? "Please set the password" : null),

                SizedBox(height: 20),

                // Mobile Number Field
                buildRoundedTextField(
                    labelText: 'Mobile Number',
                    hintText: 'Enter Your Mobile Number',
                    icon: Icons.phone,
                    keyboardType: TextInputType.phone,
                    onChanged: (value) => MobileNumber = value,
                    validator: (value) =>
                    value!.isEmpty ? "Please enter your mobile number" : null),

                SizedBox(height: 30),

                // Register Button with Rounded Corners
                InkWell(
                  onTap: registeruser,
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width - 40,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(30), // Rounded corners
                    ),
                    child: Center(
                      child: _isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                        'Register',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 4,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  ),
                  child: Text('Already Have An Account?'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to create rounded text fields
  Widget buildRoundedTextField(
      {required String labelText,
        required String hintText,
        required IconData icon,
        bool obscureText = false,
        TextInputType keyboardType = TextInputType.text,
        required Function(String) onChanged,
        required String? Function(String?) validator}) {
    return TextFormField(
      onChanged: onChanged,
      validator: validator,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: Icon(icon, color: Colors.green),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.green),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.green),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.green, width: 2.0),
        ),
      ),
    );
  }
}
