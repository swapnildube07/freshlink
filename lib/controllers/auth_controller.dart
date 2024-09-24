//import 'dart:nativewrappers/_internal/vm/lib/typed_data_patch.dart';
import 'dart:ui';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class AuthController {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;


  /// select image from gallaery or camera


  pickProfileImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();
    
    XFile? _file = await _imagePicker.pickImage(source: source);

    if( _file!=null){
      return await _file.readAsBytes();
    }else{
      print('No Image Selected');
    }
  }

  // FUNCTION TO UPLOAD STORAGE
  
  _uploadImageTOStorage(Uint8List? image)async{
   Reference ref =  _storage.ref().child('profileImages').child(_auth.currentUser!.uid);
   UploadTask uploadTask = ref.putData(image!);

   TaskSnapshot  snapshot = await uploadTask;
   String downloadUrl = await snapshot.ref.getDownloadURL();

   return downloadUrl;
  }
  Future<String> createNewUser(
      String email, String  FullName, String Password,String MobileNumber,Uint8List? image) async {
    String res = 'Some Error Occured';

    try {
      UserCredential userCredential =  await _auth.createUserWithEmailAndPassword(
          email: email, password: Password);

          String downloadUrl = await _uploadImageTOStorage(image) ;

         await _firestore.collection('buyers').doc(userCredential.user!.uid).set({

            'email': email,
            'FullName': FullName,
           'profileImage': downloadUrl,
            'password':Password,
            'MobileNumber':MobileNumber,
            'buyerID':userCredential.user!.uid,

          });

      res = 'Success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
  // FUNCTION  TO LOGIN THE CREATED USER

  Future<String> loginUser( String email , String Password)async{
       String res = 'some error Occurred';
       try{
         await  _auth.signInWithEmailAndPassword(email: email, password: Password);
         res = 'Success';
       }catch(e){
         res = e.toString();
       }
        return res;
  }
}
