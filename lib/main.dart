import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hirednow/Screens/addJob.dart';
import 'package:hirednow/Screens/companyApplicationChats.dart';
import 'package:hirednow/Screens/companyEmailVerification.dart';
import 'package:hirednow/Screens/companyHome.dart';
import 'package:hirednow/Screens/companyJobApplications.dart';
import 'package:hirednow/Screens/hireOrHired.dart';
import 'package:hirednow/Screens/loginScreen.dart';
import 'package:hirednow/Screens/signUpCompany.dart';
import 'package:hirednow/Screens/signUpUser.dart';
import 'package:hirednow/Screens/userApplicationChats.dart';
import 'package:hirednow/Screens/userApplications.dart';
import 'package:hirednow/Screens/userHome.dart';
import 'package:hirednow/Screens/userMobileVerification.dart';
import 'package:hirednow/Screens/userLocker.dart';
import 'package:hirednow/Screens/companyJobApplications.dart';
import 'package:hirednow/Screens/userProfile.dart';
import 'package:hirednow/Screens/companyProfile.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'Components/userSharedPreference.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHiveForFlutter();
  await UserSharedPreference();
  initPlatformState();
  runApp(MyApp());
}
Future<void> initPlatformState() async {
  OneSignal.shared.setAppId("202e93ee-b89e-4608-85da-fa77f3101050");
  OneSignal.shared.setExternalUserId("a4c5ac95-a62d-4114-854d-35c442212ec0");
}
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final String image="https://res.cloudinary.com/mkwebs/image/upload/v1651379032/qjrlmckldptuvv6l4g3s.png";
    final String applicationId="06ad299d-bd67-4176-9627-40207cdd7c80";
    final String jobId="73d404c2-c4e5-4ccf-b3ea-611b6e534e0d";
    final String userId="a4c5ac95-a62d-4114-854d-35c442212ec0";
    final String companyId="db5b18d9-dde3-42a8-819b-f700b6fb55c1";
    final HttpLink httpLink = HttpLink("https://hire-today.hasura.app/v1/graphql");
    Link link=httpLink;
    final AuthLink authLinkUser = AuthLink(
        getToken: () async =>
        'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiYTRjNWFjOTUtYTYyZC00MTE0LTg1NGQtMzVjNDQyMjEyZWMwIiwicm9sZSI6InVzZXIiLCJodHRwczovL2hhc3VyYS5pby9qd3QvY2xhaW1zIjp7IlgtSGFzdXJhLVVzZXItSWQiOiJhNGM1YWM5NS1hNjJkLTQxMTQtODU0ZC0zNWM0NDIyMTJlYzAiLCJYLUhhc3VyYS1Sb2xlIjoidXNlciIsIlgtSGFzdXJhLURlZmF1bHQtUm9sZSI6InVzZXIiLCJYLUhhc3VyYS1BbGxvd2VkLVJvbGVzIjpbInVzZXIiXX0sImlhdCI6MTY1ODY0NzgyOX0.N31hY8Te6YUqKkQLGBKvLHEGn3b3QU9KS7RD_o-ffUA' );


    // company
    final AuthLink authLinkCompany = AuthLink(
        getToken: () async =>
        'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiZGI1YjE4ZDktZGRlMy00MmE4LTgxOWItZjcwMGI2ZmI1NWMxIiwicm9sZSI6ImNvbXBhbnkiLCJodHRwczovL2hhc3VyYS5pby9qd3QvY2xhaW1zIjp7IlgtSGFzdXJhLVVzZXItSWQiOiJkYjViMThkOS1kZGUzLTQyYTgtODE5Yi1mNzAwYjZmYjU1YzEiLCJYLUhhc3VyYS1Sb2xlIjoiY29tcGFueSIsIlgtSGFzdXJhLURlZmF1bHQtUm9sZSI6ImNvbXBhbnkiLCJYLUhhc3VyYS1BbGxvd2VkLVJvbGVzIjpbImNvbXBhbnkiXX0sImlhdCI6MTY1ODY0ODExN30.zjIwRVFrWCjpCYxkdXXXk9UZQHb-yAHtkZ1n_f0QOfM');
    link = authLinkUser.concat(httpLink);
    // link = authLinkCompany.concat(httpLink);
    ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(
        link: link,
        // The default store is the InMemoryStore, which does NOT persist to disk
        cache: GraphQLCache(store: HiveStore()),
      ),
    );
    return GraphQLProvider(
        client: client,
        child:  MaterialApp(
          title: "HIREdNow",
          // home:UserChats(applicationId,userId,"Company","Devveloper")
          // home:ApplicationChats(applicationId,companyId,"User",image),
          home:UserLocker(userId),

          // home:JobApplications(companyId,jobId),
          // home:CompanyJobs(companyId),
          // home:UserApplications(userId),
          // home:CompanyHome(),
          // home:UserHome(),
          // home:UserProfile(userId),
          // home: SignUpUser(),
          //  home:CompanyProfile(companyId),
          // home: UserEmailVerification("rishivisvas539@gmail.com", userId),
          // home: HireOrHired(),
          // home: AddJob(),
          //  home: SignUpCompany(),
          //home: UserProfile(userId),
          // home: LoginView(),
        )
    );
  }
}

