// import 'dart:nativewrappers/_internal/vm/lib/typed_data_patch.dart';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
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

  late String email;

  late String FullName;

  late String Password;

  late String MobileNumber;

  Uint8List? _image;

  selectGalleryImage() async {
    Uint8List Im = await _authController.pickProfileImage(ImageSource.gallery);

    setState(() {
      _image = Im;
    });
  }

  captureImage() async {
    await _authController.pickProfileImage(ImageSource.camera);
  }

  registeruser() async {
    if (_image != null) {
      if (_formkey.currentState!.validate()) {
        setState(() {
          _isLoading = true;
        });
        String res = await _authController.createNewUser(
            email, FullName, Password, MobileNumber, _image);
        setState(() {
          _isLoading = false;
        });
        if (res == 'Success') {
          setState(() {
            _isLoading = false;
          });
          Get.to(LoginScreen());

          Get.snackbar(
            'Success',
            "Account  has been Created For You",
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } else {
          Get.snackbar('Error', res.toString(),
              backgroundColor: Colors.red,
              colorText: Colors.white,
              snackPosition: SnackPosition.BOTTOM);
        }
      } else {
        Get.snackbar('Form', "Form Filed is Not Valid");
      }
    } else {
      Get.snackbar(
        "No Image",
        "Please Capture or select the image",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
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
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4),
              ),
              SizedBox(
                height: 20,
              ),
              Stack(
                children: [
                  _image == null
                      ? CircleAvatar(
                          radius:
                              80, // You can change the size by adjusting the radius
                          backgroundImage: AssetImage(
                              'assets/icons/farmer.png'), // Image from assets folder
                        )
                      : CircleAvatar(
                          radius: 80,
                          backgroundImage: MemoryImage(_image!),
                        ),
                  Positioned(
                    right: 0,
                    top: 15,
                    child: IconButton(
                      onPressed: () {
                        selectGalleryImage();
                      },
                      icon: Icon(CupertinoIcons.photo),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                onChanged: (value) {
                  email = value;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your email address.';
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  hintText: 'Enter Mail Address',
                  prefixIcon: Icon(
                    Icons.email,
                    color: Colors.green,
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                onChanged: (value) {
                  FullName = value;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter your full name";
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  hintText: 'Enter Full Name',
                  prefixIcon: Icon(
                    Icons.person,
                    color: Colors.green,
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                onChanged: (value) {
                  Password = value;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please Set the Password.";
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Set Password',
                  prefixIcon: Icon(
                    Icons.lock,
                    color: Colors.green,
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                onChanged: (value) {
                  MobileNumber = value;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter your MobileNumber.";
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                  labelText: 'Mobile Number',
                  hintText: 'Enter Your Mobile Number',
                  prefixIcon: Icon(
                    Icons.phone,
                    color: Colors.green,
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  registeruser();
                },
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width - 40,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(
                      8,
                    ),
                  ),
                  child: Center(
                    child: _isLoading
                        ? CircularProgressIndicator(
                            color: Colors.white,
                          )
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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return LoginScreen();
                      },
                    ),
                  );
                },
                child: Text('Already Have An Account?'),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
