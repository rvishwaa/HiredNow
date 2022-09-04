import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class UserChats extends StatefulWidget {
  late final String applicationId, userId, companyName,jobTitle;

  UserChats(this.applicationId, this.userId, this.companyName,this.jobTitle);

  @override
  State<UserChats> createState() => _UserChatsState();
}

class _UserChatsState extends State<UserChats> {
  late final TextEditingController _message;

  void initState() {
    _message = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _message.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(
            document: gql("""query getChats(\$application_id: uuid!) {
  messages(where: {application_id: {_eq: \$application_id}}) {
    type
    value
    user_id
    company_id
  }
}"""),
            variables: {
              "application_id": widget.applicationId,
            },
            fetchPolicy: FetchPolicy.networkOnly),
        builder: (result, {refetch, fetchMore}) {
          if (result.hasException) {
            return Text(result.exception.toString());
          }

          if (result.isLoading) {
            return const Text('Loading');
          }

          List? messages = result.data?['messages'];
          print(messages);
          if (messages == null) {
            return const Text('No files');
          }
          return Mutation(
              options: MutationOptions(
                document: gql(
                    """mutation chat(\$application_id: uuid!, \$user_id: uuid!, \$value: String!) {
  insert_messages(objects: {application_id: \$application_id, user_id: \$user_id, type: "TEXT", value: \$value}) {
    affected_rows
  }
}"""),
                onCompleted: (dynamic resultData1) {
                  print(resultData1);
                },
              ),
              builder: (
                addMessage,
                result1,
              ) {
                return Scaffold(
                  backgroundColor: Colors.blueGrey,
                  appBar: AppBar(
                    title: Text(
                      widget.companyName+" - "+widget.jobTitle,
                      style: TextStyle(color: Colors.black87),
                    ),
                    backgroundColor: Colors.blueGrey,
                  ),

                  floatingActionButton: SizedBox(
                    width: 50.0,
                    height: 50.0,
                    child: RawMaterialButton(
                      shape: const CircleBorder(),
                      elevation: 0.0,
                      child: const Icon(
                        Icons.send,
                        color: Colors.blue,
                      ),
                      onPressed: () {
                        addMessage({
                          "user_id": widget.userId,
                          "application_id": widget.applicationId,
                          "value": _message.text,
                        });
                      },
                    ),
                  ),
                  // floatingActionButton: FloatingActionButton(
                  //   onPressed: () {
                  //
                  //   },
                  //   backgroundColor: Colors.blue,
                  //   child: const Icon(Icons.send),
                  // ),
                  body: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: messages.length,
                            itemBuilder: (context, index) {
                              return messages[index]["user_id"] == widget.userId
                                  ? ListTile(
                                trailing: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.blue
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      messages[index]["value"],
                                      textAlign: TextAlign.start,
                                      style: const TextStyle(
                                        // fontWeight: FontWeight.w500,
                                          fontFamily: 'Roboto',
                                          fontSize: 20,
                                          color: Colors.black),
                                    ),
                                  ),
                                ),
                              ):ListTile(
                                      // leading: ConstrainedBox(
                                      //   constraints: BoxConstraints(
                                      //     minHeight: 80.0,
                                      //     minWidth: 150.0,
                                      //     // maxHeight: 30.0,
                                      //     // maxWidth: 30.0,
                                      //   ),
                                      //   child: Container(
                                      //     padding: const EdgeInsets.all(10),
                                      //     decoration: BoxDecoration(
                                      //         color: Colors.blue,
                                      //         borderRadius:
                                      //             BorderRadius.circular(25)),
                                      //     child: Center(
                                      //         child: Text(
                                      //       messages[index]["value"],
                                      //       textAlign: TextAlign.start,
                                      //       style: const TextStyle(
                                      //           fontWeight: FontWeight.w500,
                                      //           fontFamily: 'Roboto',
                                      //           fontSize: 20,
                                      //           color: Colors.white),
                                      //     )),
                                      //   ),
                                      // ),
                                      leading: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius: BorderRadius.circular(10)
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            messages[index]["value"],
                                            textAlign: TextAlign.start,
                                            style: const TextStyle(
                                                // fontWeight: FontWeight.w500,
                                                fontFamily: 'Roboto',
                                                fontSize: 20,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    )
                                   ;
                              // return Text(messages[index]["value"]);
                            }),
                      ),
                      TextField(
                        controller: _message,
                        autocorrect: true,
                        enableSuggestions: true,
                        decoration:
                            const InputDecoration(hintText: 'Send Message'),
                        cursorHeight: 25,
                      ),
                      const SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                );
              });
        });
  }
}

class Self extends StatelessWidget {
  String message;

  Self(this.message);

  @override
  Widget build(BuildContext context) {
    return Container(child: Text(message));
  }
}

class Other extends StatelessWidget {
  String message;

  Other(this.message);

  @override
  Widget build(BuildContext context) {
    return Container(child: Text(message));
  }
}
