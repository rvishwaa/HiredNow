

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class CompanyJobs extends StatefulWidget {
  late final String companyId;

  CompanyJobs(this.companyId);

  @override
  State<CompanyJobs> createState() => _CompanyJobsState();
}

class _CompanyJobsState extends State<CompanyJobs> {
  @override
  Widget build(BuildContext context) {
    return  Query(
        options: QueryOptions(
            document: gql("""query getJobs(\$company_id: uuid!) {
  jobs(where: {company_id: {_eq: \$company_id}}) {
    id
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
    applications_aggregate{
      aggregate
      {
        count
      }
    }
  }
}"""),
            variables: {
              "company_id": widget.companyId,
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

          List? jobs = result.data?['jobs'];
          print(jobs);
          if (jobs == null) {
            return const Text('No files');
          }
          return Scaffold(
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