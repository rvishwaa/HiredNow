import 'dart:ui';

import "package:flutter/material.dart";
import 'package:hirednow/Constants/constants.dart';

// import '../Images';
import '../Components/dashDivider.dart';
import '../Constants/constants.dart';

class HireOrHired extends StatelessWidget {
  const HireOrHired({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // const Text(
              //   "Are you a",
              //   style: TextStyle(
              //       color: Colors.greenAccent,
              //       fontFamily: 'Roboto',
              //       fontSize: 25,
              //       fontWeight: FontWeight.bold),
              // ),
              const SizedBox(
                height: 30,
              ),
              const CircleAvatar(
                radius: 80,
                backgroundImage: AssetImage('Images/recruiter.png'),
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text(
                  'Recruiter',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Roboto',
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.black38,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // <-- Radius
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const DashDivider(),
              const SizedBox(
                height: 30,
              ),
              const CircleAvatar(
                radius: 80,
                backgroundImage: AssetImage('Images/jobSeeker.png'),
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Job Seeker',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Roboto',
                    )),
                style: ElevatedButton.styleFrom(
                  primary: Colors.black38,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // <-- Radius
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
