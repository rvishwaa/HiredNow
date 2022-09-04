import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class UserMobileVerification extends StatefulWidget {
  String mobileNumber;
  String companyId;
  UserMobileVerification(this.mobileNumber,this.companyId);

  @override
  State<UserMobileVerification> createState() => _UserMobileVerificationState();
}

class _UserMobileVerificationState extends State<UserMobileVerification> {
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
            'Mobile Verification',
            style: TextStyle(color: Colors.black87),
          ),
          centerTitle: true,
          backgroundColor: Colors.blueGrey,
        ),
        body: Mutation(
            options: MutationOptions(
              document: gql("""mutation sendOtp(\$type: String!,\$mobile:String) {
                              c_send_otp(type: \$type,mobile:\$mobile) {
                              message
                              otp_hash
                              }
                            }"""),
              onCompleted: (dynamic resultData1) {
                print(resultData1);
                if(resultData1!=null)
                  {
                    setState(() {
                      otp_hash=resultData1['c_send_otp']['otp_hash'];
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
                    document: gql("""mutation verifyOtp(\$otp: String!, \$otp_hash: String!, \$type: String!, \$company_id: uuid!, \$mobile:String) {
  verify_otp(otp: \$otp, otp_hash: \$otp_hash, type: \$type, company_id: \$company_id,mobile:\$mobile) {
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
                                text: 'Mobile Number: ',
                                style: const TextStyle(
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: '   ' + widget.mobileNumber,
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
                                        "type":"mobile",
                                        "mobile":widget.mobileNumber,
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
                                        "type":"mobile",
                                        "mobile":widget.mobileNumber,
                                        "otp":_otp.text,
                                        "otp_hash":otp_hash,
                                        "company_id":widget.companyId,
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
