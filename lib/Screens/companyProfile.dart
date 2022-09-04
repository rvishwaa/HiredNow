import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../Constants/constants.dart';

class CompanyProfile extends StatefulWidget {
  late final String companyId;

  CompanyProfile(this.companyId);

  @override
  State<CompanyProfile> createState() => _CompanyProfileState();
}

class _CompanyProfileState extends State<CompanyProfile> {
  @override
  Widget build(BuildContext context) {
    return  Query(
        options: QueryOptions(
            document: gql("""query getUser(\$company_id: uuid!) {
  company(where: {id: {_eq: \$company_id}}) {
    description
    email
    mobile
    name
    proof
    proof_type
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

          dynamic? details = result.data?['company'][0];
          print(details);
          if (details == null) {
            return const Text('Error');
          }
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
                        Text(
                          "Proof :   ${details['proof_type']}",
                          style: const TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                              color: Colors.white),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        CircleAvatar(
                          radius: 80,
                          backgroundImage: NetworkImage(details['proof']),
                        ),
                        const SizedBox(
                          height: 60,
                        ),
                        Text(
                          "Company Name:   ${details['name']}",
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
                          "Description :    ${details['description']}",
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
                          "Email:  ${details['email']}",
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
                          "mobile: ${details['mobile']}",
                          style: const TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                              color: Colors.white),
                        ),
                      ],
                    ));
        });
  }
}