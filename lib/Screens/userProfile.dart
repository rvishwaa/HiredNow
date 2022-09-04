import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hirednow/Constants/constants.dart';

class UserProfile extends StatefulWidget {
  late final String userId;

  UserProfile(this.userId);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(
            document: gql("""query getUser(\$user_id: uuid!) {
              users(where: {id: {_eq: \$user_id}}) {
                dob
                email
                mobile
                name
                avatar
              }
            }"""),
            variables: {
              "user_id": widget.userId,
            },
            fetchPolicy: FetchPolicy.networkOnly),
        builder: (result, {refetch, fetchMore}) {
          if (result.hasException) {
            return Text(result.exception.toString());
          }

          if (result.isLoading) {
            return const Text('Loading');
          }

          List? details = result.data?['users'];
          print(details);
          String name = result.data!['users'][0]['name'];
          String dob = result.data?['users'][0]['dob'];
          String email = result.data?['users'][0]['email'];
          String mobile = result.data?['users'][0]['mobile'];
          String avatar = result.data?['users'][0]['avatar'];

          if (details == null) {
            return const Text('No files');
          }
          return Mutation(
              options: MutationOptions(
                document: gql(
                    """mutation change_avatar(\$avatar: String!, \$user_id: uuid!) {
                  change_avatar(avatar: \$avatar, user_id: \$user_id) {
                    avatar
                  }
                }
                """),
                onCompleted: (dynamic resultData1) {
                  refetch!();
                  print(resultData1);
                },
              ),
              builder: (
                changeAvatar,
                result1,
              ) {
                return Scaffold(
                    backgroundColor: AppColors.primaryBackground,
                    appBar: AppBar(
                      backgroundColor: AppColors.primaryBackground,
                      title: Text("Profile"),
                      centerTitle: true,
                    ),
                    body: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 30,
                          width: double.infinity,
                        ),
                        CircleAvatar(
                          radius: 80,
                          backgroundImage: NetworkImage(details[0]['avatar']),
                        ),
                        const SizedBox(
                          height: 60,
                        ),
                        Text(
                          "Name:   $name",
                          style: const TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                              color: Colors.white),
                        ),
                        const SizedBox(
                          height: 60,
                        ),
                        Text(
                          "Dob:    $dob",
                          style: const TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                              color: Colors.white),
                        ),
                        const SizedBox(
                          height: 60,
                        ),
                        Text(
                          "Email:  $email",
                          style: const TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                              color: Colors.white),
                        ),
                        const SizedBox(
                          height: 60,
                        ),
                        Text(
                          "mobile: $mobile",
                          style: const TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                              color: Colors.white),
                        ),
                      ],
                    ));
              });
        });
  }
}
