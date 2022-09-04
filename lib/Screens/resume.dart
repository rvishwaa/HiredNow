import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class Resume extends StatefulWidget {
  late final String userId;

  Resume(this.userId);

  @override
  State<Resume> createState() => _ResumeState();
}

class _ResumeState extends State<Resume> {
  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(
            document: gql(""""""),
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

          List? resumes = result.data?['jobs'];
          print(resumes);
          return Mutation(
              options: MutationOptions(
                document: gql(""""""),
                onCompleted: (dynamic resultData2) {
                  print(resultData2);
                  refetch!();
                },
              ),
              builder: (
                addResume,
                result2,
              ) {
                return Scaffold(
                  floatingActionButton: FloatingActionButton(
                    onPressed: () {},
                    backgroundColor: Colors.green,
                    child: const Icon(Icons.navigation),
                  ),
                  body: Text("hi"),
                );
              });
        });
  }
}
