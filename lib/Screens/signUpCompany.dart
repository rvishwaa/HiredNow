import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:path/path.dart' as p;
import "package:flutter/material.dart";
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:image_picker/image_picker.dart';
import '../Constants/constants.dart';

class SignUpCompany extends StatefulWidget {
  @override
  State<SignUpCompany> createState() => _SignUpCompanyState();
}

class _SignUpCompanyState extends State<SignUpCompany> {
  late final TextEditingController _company;
  late final TextEditingController _mobile;
  late final TextEditingController _password;
  late final TextEditingController _email;
  late final TextEditingController _description;
  late String _image;

  void initState() {
    _image = "";
    _description = TextEditingController();
    _email = TextEditingController();
    _company = TextEditingController();
    _password = TextEditingController();
    _mobile = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _mobile.dispose();
    _company.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> getFromGallery() async {
    XFile? pickedFile = (await ImagePicker().pickImage(
      source: ImageSource.gallery,
    ));
    print(pickedFile);
    print(pickedFile?.path);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      Uint8List imagebytes = await imageFile.readAsBytes(); //convert to bytes
      String base64string = base64.encode(imagebytes);
      print(base64string); //convert bytes to base64 string
      setState(() {
        print("haha");
        _image = "data:image/" +
            p.extension(imageFile.path).substring(1) +
            ";base64," +
            base64string;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBackground,
        title: Text("Sign Up"),
        centerTitle: true,
      ),
      body: Mutation(
          options: MutationOptions(
            document: gql(
                """mutation CompanySignup(\$email: String!, \$mobile: String!, \$name: String!, \$password: String!, \$proof: String!, \$proof_type: String!, \$description: String!) {
  c_signup(email: \$email, mobile: \$mobile, name: \$name, password: \$password, proof: \$proof, proof_type: \$proof_type, description: \$description) {
    user_id
    auth_token
  }
}"""),
            onCompleted: (dynamic resultData1) {
              print(resultData1);
            },
            onError: (dynamic error)
              {
                print(error);
              }
          ),
          builder: (
            signup,
            result1,
          ) {
            return SingleChildScrollView(
              child: Container(
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20, top: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextField(
                        controller: _company,
                        autocorrect: false,
                        enableSuggestions: false,
                        decoration:
                            const InputDecoration(hintText: 'Company Name'),
                        cursorHeight: 25,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: _description,
                        autocorrect: false,
                        enableSuggestions: false,
                        decoration: const InputDecoration(
                            hintText: 'Company Description'),
                        cursorHeight: 25,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: _mobile,
                        autocorrect: false,
                        enableSuggestions: false,
                        decoration:
                            const InputDecoration(hintText: 'Mobile number'),
                        cursorHeight: 25,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: _password,
                        autocorrect: false,
                        enableSuggestions: false,
                        decoration: const InputDecoration(hintText: 'Password'),
                        cursorHeight: 25,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: _email,
                        autocorrect: false,
                        enableSuggestions: false,
                        decoration: const InputDecoration(hintText: 'Email'),
                        cursorHeight: 25,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      DropdownButton<String>(
                        hint: const Text('Proof Type'),
                        items: <String>['a', 'b', 'c'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (_) {},
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          getFromGallery();
                        },
                        child: _image == ""
                            ? const Text(
                                'Upload Proof',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Roboto',
                                ),
                              )
                            : Image.memory(
                                base64Decode(_image.split(',')[1]),
                                height: 200,
                                width: 150,
                                fit: BoxFit.fill,
                              ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.black38,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12), // <-- Radius
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          print(_image);
                          print(_company.text);
                          signup({
                            "name": _company.text,
                            "mobile": _mobile.text,
                            "proof_type": "drop",
                            "email": _email.text,
                            "password": _password.text,
                            "proof": _image,
                            "description": _description.text,
                          });
                        },
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Roboto',
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.black38,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12), // <-- Radius
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
