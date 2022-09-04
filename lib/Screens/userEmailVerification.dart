import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class UserEmailVerification extends StatefulWidget {
  String email;
  String userId;

  UserEmailVerification(this.email, this.userId);

  @override
  State<UserEmailVerification> createState() => _UserEmailVerificationState();
}

class _UserEmailVerificationState extends State<UserEmailVerification> {
  late final TextEditingController _otp;
  late String otp_hash;

  @override
  void initState() {
    _otp = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _otp.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueGrey,
        appBar: AppBar(
          title: const Text(
            'Email Verification',
            style: TextStyle(color: Colors.black87),
          ),
          centerTitle: true,
          backgroundColor: Colors.blueGrey,
        ),
        body: Mutation(
            options: MutationOptions(
              document:
                  gql("""mutation sendOtp(\$type: String!,\$email:String) {
                              send_otp(type: \$type,email:\$email) {
                              message
                              otp_hash
                              }
                            }"""),
              onCompleted: (dynamic resultData1) {
                print(resultData1);
                if (resultData1 != null) {
                  setState(() {
                    otp_hash = resultData1['send_otp']['otp_hash'];
                  });
                }
              },
            ),
            builder: (
              sendotp,
              result1,
            ) {
              return Mutation(
                  options: MutationOptions(
                    document: gql(
                        """mutation verifyOtp(\$otp: String!, \$otp_hash: String!, \$type: String!, \$user_id: uuid!, \$email:String) {
  verify_otp(otp: \$otp, otp_hash: \$otp_hash, type: \$type, user_id: \$user_id,email:\$email) {
    mobile
    type
    verified
  }
}"""),
                    onCompleted: (dynamic resultData2) {
                      print(resultData2);
                    },
                  ),
                  builder: (
                    verifyotp,
                    result2,
                  ) {
                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 40.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 30,
                            ),
                            RichText(
                              text: TextSpan(
                                text: 'Email: ',
                                style: const TextStyle(
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: '   ' + widget.email,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Roboto',
                                          color: Colors.white,
                                          fontSize: 25)),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextField(
                              controller: _otp,
                              autocorrect: false,
                              enableSuggestions: false,
                              decoration:
                                  const InputDecoration(hintText: 'Otp'),
                              cursorHeight: 25,
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      sendotp({
                                        "type": "email",
                                        "mobile": widget.email,
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
                                        borderRadius: BorderRadius.circular(
                                            12), // <-- Radius
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 30,
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      verifyotp({
                                        "type": "email",
                                        "email": widget.email,
                                        "otp": _otp.text,
                                        "otp_hash": otp_hash,
                                        "user_id": widget.userId,
                                      });
                                    },
                                    child: const Text(
                                      ' Verify ',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: 'Roboto',
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.black38,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            12), // <-- Radius
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  });
            }));
  }
}
