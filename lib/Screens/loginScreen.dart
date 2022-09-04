import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../Constants/constants.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _otp;
  late final TextEditingController _mobile;
  late bool withPassword;
  late bool getOtp;
  late String type;
  late String otp_hash;
  @override
  void initState() {
    type = "mobile";
    withPassword = true;
    getOtp = false;
    _email = TextEditingController();
    _mobile = TextEditingController();
    _password = TextEditingController();
    _otp = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _mobile.dispose();
    _email.dispose();
    _password.dispose();
    _otp.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: Colors.blueGrey,
        appBar: AppBar(
          backgroundColor: AppColors.primaryBackground,
          title: const Center(child: Text('Login')),
        ),
        body: Mutation(
            options: MutationOptions(
              document: gql("""
mutation loginPassword(\$type: String!, \$password: String!, \$email: String,\$mobile: String) {
  login_password(type: \$type, password: \$password, mobile: \$mobile,email: \$email) {
    auth_token
    user_id
  }
}"""),
              // this is the mutation string you just created
              onCompleted: (dynamic resultData1) {
                print(resultData1);
              },
            ),
            builder: (
              loginpassword,
              result1,
            ) {
              return Mutation(
                  options: MutationOptions(
                    document: gql(
                        """mutation loginOtp(\$email: String!, \$otp: String!, \$otp_hash: String!, \$type: String!,\$mobile:String!) {
  login_otp(otp_hash: \$otp_hash, type: \$type, email: \$email, otp: \$otp,mobile:\$mobile) {
    auth_token
    user_id
  }
}"""),
                    // this is the mutation string you just created
                    onCompleted: (dynamic resultData2) {
                      print(resultData2);
                    },
                    onError: (error2){
                      print(error2);
                    }
                  ),
                  builder: (
                    loginotp,
                    result2,
                  ) {
                    return Mutation(
                        options: MutationOptions(
                          document: gql(
                              """mutation sendOtp(\$type: String!, \$email: String,\$mobile:String) {
                              send_otp(type: \$type, email: \$email,mobile:\$mobile) {
                              message
                              otp_hash
                              }
                            }"""),
                          // this is the mutation string you just created

                            onError: (error3){
                              print(error3);
                            },
                          onCompleted: (dynamic resultData3) {
                            print(resultData3);
                            if(resultData3!=null){
                            setState(() {
                              otp_hash=resultData3['send_otp']['otp_hash'];
                            });
                            }
                          },
                        ),
                        builder: (
                          sendotp,
                          result3,
                        ) {
                          return SingleChildScrollView(
                            child: Column(
                              children: [
                                Container(
                                  height: 60,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 60,
                                        width: size.width / 2,
                                        color: withPassword
                                            ? Colors.black38
                                            : Colors.white,
                                        child: TextButton(
                                          onPressed: () {
                                            setState(() {
                                              withPassword = !withPassword;
                                            });
                                          },
                                          child: Text(
                                            'With Password',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontFamily: 'Roboto',
                                                color: withPassword
                                                    ? Colors.white
                                                    : Colors.black87),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 60,
                                        width: size.width / 2,
                                        color: !withPassword
                                            ? Colors.black38
                                            : Colors.white,
                                        child: TextButton(
                                          onPressed: () {
                                            setState(() {
                                              withPassword = !withPassword;
                                            });
                                          },
                                          child: Text(
                                            '  With OTP   ',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontFamily: 'Roboto',
                                                color: !withPassword
                                                    ? Colors.white
                                                    : Colors.black87),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                const Divider(
                                  height: 1,
                                  thickness: 2,
                                  color: Colors.black38,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                  left: 20.0, right: 20, top: 60),
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  DropdownButton<String>(
                                    value: type,
                                    items: <String>['email', 'mobile']
                                        .map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (selectedItem) => setState(() {
                                      type = selectedItem!;
                                    }),
                                  ),
                                  const SizedBox(height: 20,),
                                  type=="email"?TextField(
                                    controller: _email,
                                    autocorrect: false,
                                    enableSuggestions: false,
                                    decoration: const InputDecoration(
                                        hintText: 'Email'),
                                    cursorHeight: 25,
                                  ):TextField(
                                    controller: _mobile,
                                    autocorrect: false,
                                    enableSuggestions: false,
                                    decoration: const InputDecoration(
                                        hintText: 'Mobile number'),
                                    cursorHeight: 25,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  withPassword
                                      ? TextField(
                                          controller: _password,
                                          obscureText: true,
                                          autocorrect: false,
                                          enableSuggestions: false,
                                          decoration: const InputDecoration(
                                              hintText: 'Password'),
                                        )
                                      : Container(),
                                  !withPassword
                                      ? TextField(
                                          controller: _otp,
                                          autocorrect: false,
                                          enableSuggestions: false,
                                          decoration: const InputDecoration(
                                              hintText: 'OTP'),
                                        )
                                      : Container(),
                                  const SizedBox(
                                    height: 40,
                                  ),
                                  withPassword
                                      ? ElevatedButton(
                                          onPressed: () {
                                            loginpassword({
                                              "type":type,
                                              "mobile":_mobile.text,
                                              "password":_password.text,
                                              "email":_email.text,
                                            });
                                          },
                                          child: const Text(
                                            'Login',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontFamily: 'Roboto',
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.black38,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      12), // <-- Radius
                                            ),
                                          ),
                                        )
                                      : Container(),
                                  !withPassword
                                      ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          ElevatedButton(
                                              onPressed: () {
                                                sendotp({
                                                  "type":type,
                                                  "email":_email.text,
                                                  "mobile":_mobile.text,
                                                });
                                              },
                                              child: const Text(
                                                'Get OTP',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontFamily: 'Roboto',
                                                ),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                primary: Colors.black38,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12), // <-- Radius
                                                ),
                                              ),
                                            ),
                                          SizedBox(width: 30,),
                                          ElevatedButton(
                                            onPressed: () {
                                              loginotp({
                                                "type":type,
                                                "email":_email.text,
                                                "mobile":_mobile.text,
                                                "otp":_otp.text,
                                                "otp_hash":otp_hash,
                                              });
                                            },
                                            child: const Text(
                                              'Login',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontFamily: 'Roboto',
                                              ),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.black38,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(
                                                    12), // <-- Radius
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                      : Container(),
                                ],
                                  ),
                                )
                              ],
                            ),
                          );
                        });
                  });
            }));
  }
}
