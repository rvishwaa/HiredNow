import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class ResumeChats extends StatefulWidget {
  late final String userId,resumeId,name;
  ResumeChats( this.userId,this.resumeId,this.name);

  @override
  State<ResumeChats> createState() => _ResumeChatsState();
}

class _ResumeChatsState extends State<ResumeChats> {
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
            document: gql(""""""),
            variables: {
              "resume_id": widget.resumeId,
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
                    """"""),
                onCompleted: (dynamic resultData1) {
                  print(resultData1);
                },
              ),
              builder: (
                addMessage,
                result1,
              ) {
                print(result1);
                return Scaffold(
                backgroundColor: Colors.blueGrey,
                appBar: AppBar(
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
                        "user_id":widget.userId,
                        "resume_id":widget.resumeId,
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
                            return messages[index]["by_user"]
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
