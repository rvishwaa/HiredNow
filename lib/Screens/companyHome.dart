import 'dart:ui';

import "package:flutter/material.dart";

class CompanyHome extends StatelessWidget {
  const CompanyHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  const CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage('Images/profile.png'),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('   Profile   ',
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
                  ),
                ],
              ),
              const SizedBox(
                width: 20,
              ),
              Column(
                children: [
                  const CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage('Images/postedJobs.png'),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                      onPressed: () {},
                      child: const Text('Posted Jobs',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Roboto',
                          )),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black38,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12), // <-- Radius
                        ),
                      )),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 60,
          ),
          const CircleAvatar(
            radius: 60,
            backgroundImage: AssetImage('Images/addJob.png'),
          ),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton(
              onPressed: () {},
              child: const Text('Add Job',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Roboto',
                  )),
              style: ElevatedButton.styleFrom(
                primary: Colors.black38,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // <-- Radius
                ),
              )),
        ],
      ),
    );
  }
}
