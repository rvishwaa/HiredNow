import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hirednow/Constants/constants.dart';

class JobApplications extends StatefulWidget {
  late final String companyId;
  late final String jobId;

  JobApplications(this.companyId, this.jobId);

  @override
  State<JobApplications> createState() => _JobApplicationsState();
}

class _JobApplicationsState extends State<JobApplications> {
  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(
            document: gql("""query getApplications(\$job_id: uuid!) {
  applications(where: {job_id: {_eq: \$job_id}}) {
    attachments {
      name
      type
      value
    }
    status
    user{
      id 
      avatar
      email
      mobile
      dob
    }
  }
}"""),
            variables: {
              "job_id": widget.jobId,
            },
            fetchPolicy: FetchPolicy.networkOnly),
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
          return Scaffold(
            backgroundColor: AppColors.primaryBackground,
            floatingActionButton: FloatingActionButton(
              onPressed: () {},
              backgroundColor: Colors.green,
              child: const Icon(Icons.navigation),
            ),
            appBar: AppBar(
              title: Text('Job Applications'),
              centerTitle: true,
              backgroundColor: AppColors.primaryBackground,
            ),
            body: ListView.builder(
              itemCount: applications.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text("Hii"),
                );
              },
            ),
          );
        });
  }
}
