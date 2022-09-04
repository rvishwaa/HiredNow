

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class UserApplications extends StatefulWidget {
  late final String userId;

  UserApplications(this.userId);

  @override
  State<UserApplications> createState() => _UserApplicationsState();
}

class _UserApplicationsState extends State<UserApplications> {
  @override
  Widget build(BuildContext context) {
    return  Query(
        options: QueryOptions(
            document: gql("""query getApplications(\$user_id: uuid!) {
  applications(where: {user_id: {_eq: \$user_id}}) {
		messages_aggregate{
      aggregate{
        count
      }
    }    
    attachments {
      name
      type
      value
    }
    status
    job{
      name
    description
    district
    duration
    job_title
    last_date
    status
    salary
    salary_type
    requirements
    duration_type 
		company{
      avatar
      email
      mobile
      name
      description
    }    
    }
  }
}"""),
            variables: {
              "user_id": widget.userId,
            },
            fetchPolicy: FetchPolicy.networkOnly
        ),
        builder: (result, {refetch, fetchMore}) {
          if (result.hasException) {
            return Text(result.exception.toString());
          }

          if (result.isLoading) {
            return const Text('Loading');
          }

          List? applications = result.data?['applications'];
          print(applications);
          if (applications == null) {
            return const Text('No files');
          }
          return  Scaffold(
                          floatingActionButton: FloatingActionButton(
                            onPressed: () {
                            },
                            backgroundColor: Colors.green,
                            child: const Icon(Icons.navigation),
                          ),
                          body:Text("hi"),
                          );
                    });
  }
}