import "package:flutter/material.dart";
import 'package:graphql_flutter/graphql_flutter.dart';

import '../Constants/constants.dart';

class SignUpUser extends StatefulWidget {
  @override
  State<SignUpUser> createState() => _SignUpUserState();
}

class _SignUpUserState extends State<SignUpUser> {
  late final TextEditingController _name;
  late final TextEditingController _mobile;
  late final TextEditingController _dob;
  late final TextEditingController _password;
  late final TextEditingController _email;
  late String _userId;
  late String _authToken;

  void initState() {
    _email = TextEditingController();
    _name = TextEditingController();
    _dob = TextEditingController();
    _password = TextEditingController();
    _mobile = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _dob.dispose();
    _mobile.dispose();
    _password.dispose();
    _name.dispose();
    super.dispose();
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
                """ mutation signup(\$name: String!, \$email: String!, \$mobile: String!, \$password: String!, \$dob: String!) {
  signup(email: \$email, name: \$name, mobile: \$mobile, password: \$password, dob: \$dob) {
    auth_token
    user_id
  }
}"""), // this is the mutation string you just created
            onCompleted: (dynamic resultData) {
              print(resultData);
            },
          ),
          builder: (
            signup,
            result,
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
                        controller: _name,
                        autocorrect: false,
                        enableSuggestions: false,
                        decoration: const InputDecoration(hintText: 'Name'),
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
                        controller: _dob,
                        autocorrect: false,
                        enableSuggestions: false,
                        decoration: const InputDecoration(
                            hintText: 'DOB (eg: 04/02/2001)'),
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
                      TextField(
                        controller: _password,
                        autocorrect: false,
                        obscureText: true,
                        enableSuggestions: false,
                        decoration: const InputDecoration(hintText: 'Password'),
                        cursorHeight: 25,
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          signup({
                            "name": _name.text,
                            "mobile": _mobile.text,
                            "dob": _dob.text,
                            "email": _email.text,
                            "password": _password.text,
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
