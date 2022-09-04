import "package:flutter/material.dart";
import 'package:graphql_flutter/graphql_flutter.dart';

class AddJob extends StatefulWidget {
  const AddJob({Key? key}) : super(key: key);

  @override
  State<AddJob> createState() => _AddJobState();
}

class _AddJobState extends State<AddJob> {
  late final TextEditingController _description;
  late final TextEditingController _name;
  late final TextEditingController _requirements;
  late final TextEditingController _salary;
  late final TextEditingController _duration;
  late final TextEditingController _attachments;
  late final TextEditingController _lastDate;
  late String? district,jobTitle,durationType,salaryType;
  List<String> durationTypes=["hours","days","weeks","months"],salaryTypes=["/hour","/month","-total"];

  @override
  void initState() {
    _description = TextEditingController();
    _name = TextEditingController();
    _requirements = TextEditingController();
    _duration = TextEditingController();
    _attachments = TextEditingController();
    _salary = TextEditingController();
    _lastDate = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _description.dispose();
    _name.dispose();
    _requirements.dispose();
    _duration.dispose();
    _salary.dispose();
    _attachments.dispose();
    _lastDate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('Add Job'),
        centerTitle: true,
      ),
      body: Query(
          options: QueryOptions(
            document: gql("""query jobs{
  job_titles{
     name
  }
  districts{
    name
  }
}"""),
              fetchPolicy: FetchPolicy.networkOnly
          ),
        builder: (result, {refetch, fetchMore}) {
            if (result.hasException) {
              return Text(result.exception.toString());
            }

            if (result.isLoading) {
              return const Text('Loading');
            }


            List<String> jobTitles=result.data!["job_titles"].map<String>((i)=>i['name'].toString()).toList();
            List<String> districts = result.data!["districts"].map<String>((i)=>i['name'].toString()).toList();
            return Mutation(
                options: MutationOptions(
                  document: gql(
                      """mutation addJob(\$company_id: uuid!, \$description: String!, \$district: String!, \$duration: Int!, \$duration_type: String!, \$job_title: String!, \$last_date: date!, \$name: String!, \$salary: Int!, \$salary_type: String!, \$requirements:String!,\$attachments_required:String!) {
  insert_jobs(objects: {company_id: \$company_id, description: \$description, district: \$district, duration: \$duration, duration_type: \$duration_type, job_title: \$job_title, last_date: \$last_date, name: \$name, salary: \$salary, salary_type: \$salary_type, requirements: \$requirements,attachments_required:\$attachments_required, status: "POSTED"}) {
    affected_rows
  }
}"""),
                  onCompleted: (dynamic resultData1) {
                    print(resultData1);
                  },
                ),
                builder: (
                  addJob,
                  result1,
                ) {
                  return SingleChildScrollView(
                    child: Container(
                      // color: Colors.blueGrey,
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 20, right: 20, top: 60),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            TextField(
                              controller: _name,
                              autocorrect: false,
                              enableSuggestions: false,
                              decoration: const InputDecoration(
                                  hintText: 'Name of the job'),
                              cursorHeight: 25,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextField(
                              controller: _description,
                              autocorrect: false,
                              enableSuggestions: false,
                              decoration: const InputDecoration(
                                  hintText: 'About the job'),
                              cursorHeight: 25,
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            const SizedBox(
                              height: 10,
                            ),
                            DropdownButton<String>(
                              hint: const Text('Job Title'),
                              items: jobTitles
                                  .map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? val) {
                                setState(() {
                                  jobTitle=val;
                                });
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            DropdownButton<String>(
                              hint: const Text('District'),
                              items: districts
                                  .map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? val) {
                                setState(() {
                                  district=val;
                                });
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextField(
                              controller: _requirements,
                              autocorrect: false,
                              enableSuggestions: false,
                              decoration: const InputDecoration(
                                  hintText: 'Requirements'),
                              cursorHeight: 25,
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            TextField(
                              controller: _attachments,
                              autocorrect: false,
                              enableSuggestions: false,
                              decoration: const InputDecoration(
                                  hintText: 'Attachments Required'),
                              cursorHeight: 25,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextField(
                              controller: _salary,
                              autocorrect: false,
                              enableSuggestions: false,
                              decoration:
                                  const InputDecoration(hintText: 'Salary'),
                              cursorHeight: 25,
                            ),
                            const SizedBox(height: 20),
                            DropdownButton<String>(
                              hint: const Text('Salary Type'),
                              items: salaryTypes.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? val) {
                                setState(() {
                                  salaryType=val;
                                });
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextField(
                              controller: _duration,
                              autocorrect: false,
                              enableSuggestions: false,
                              decoration:
                              const InputDecoration(hintText: 'Duration'),
                              cursorHeight: 25,
                            ),
                            const SizedBox(height: 20),
                            DropdownButton<String>(
                              hint: const Text('Duration Type'),
                              items: durationTypes.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? val) {
                                setState(() {
                                  durationType=val;
                                });
                              },
                            ),
                            TextField(
                              controller: _lastDate,
                              autocorrect: false,
                              enableSuggestions: false,
                              decoration: const InputDecoration(
                                  hintText: 'Last Date to apply (eg: 04/02/2001)'),
                              cursorHeight: 25,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                print(district);
                                print(jobTitle);
                                print(salaryType);
                                print(durationType);
                              },
                              child: const Text(
                                'Post Job',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.black38,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(12), // <-- Radius
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                });
          }),
    );
  }
}
